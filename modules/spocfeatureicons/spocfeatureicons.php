<?php

if (!defined('_PS_VERSION_')) {
    exit;
}

class Spocfeatureicons extends Module
{
    const DB_FIELD = 'spoc_icon';
    const UPLOAD_FIELD = 'spoc_feature_icon';
    const DELETE_FIELD = 'spoc_delete_feature_icon';
    const UPLOAD_DIR = 'spoc_feature_icons/';
    const MAX_FILE_SIZE = 524288;

    private static $featureIconCache = null;
    private static $adminHooksChecked = false;
    private static $handledFeatureIconSubmits = [];

    public function __construct()
    {
        $this->name = 'spocfeatureicons';
        $this->tab = 'front_office_features';
        $this->version = '1.0.3';
        $this->author = 'SPOC';
        $this->need_instance = 0;
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('SPOC feature icons');
        $this->description = $this->l('Adds an icon upload field to product features and displays it on product pages.');
        $this->ps_versions_compliancy = [
            'min' => '1.7.0.0',
            'max' => _PS_VERSION_,
        ];
    }

    public function install()
    {
        return parent::install()
            && $this->installSql()
            && $this->ensureUploadDirectory()
            && $this->registerModuleHooks();
    }

    public function uninstall()
    {
        return $this->uninstallSql()
            && parent::uninstall();
    }

    public function hookDisplayHeader(array $params = [])
    {
        if (!isset($this->context->controller) || $this->context->controller->php_self !== 'product') {
            return;
        }

        $this->context->smarty->assign('spoc_feature_icons', self::getFeatureIconUrls());
    }

    public function hookDisplayBackOfficeHeader(array $params = [])
    {
        $this->addFeatureAdminAssets($params);
    }

    public function hookActionAdminControllerSetMedia(array $params = [])
    {
        $this->addFeatureAdminAssets($params);
    }

    private function addFeatureAdminAssets(array $params = [])
    {
        $controller = Tools::strtolower((string) Tools::getValue('controller'));
        $requestUri = isset($_SERVER['REQUEST_URI']) ? (string) $_SERVER['REQUEST_URI'] : '';

        if (!$this->isFeatureAdminPage($controller, $requestUri)) {
            return;
        }

        $this->ensureAdminHooks();

        $isFeatureFormPage = $this->isFeatureAdminFormPage($requestUri);
        $this->context->controller->addCSS($this->_path . 'views/css/admin.css');

        if ($isFeatureFormPage) {
            $idFeature = $this->resolveFeatureId($params);
            $filename = $idFeature ? $this->getIconFilenameByFeature($idFeature) : '';

            $this->context->controller->addJS($this->_path . 'views/js/admin.js');
        }

        if ($isFeatureFormPage && class_exists('Media')) {
            Media::addJsDef([
                'spocFeatureIconsField' => [
                    'uploadName' => self::UPLOAD_FIELD,
                    'deleteName' => self::DELETE_FIELD,
                    'label' => $this->l('Icône de caractéristique'),
                    'deleteLabel' => $this->l('Supprimer l’icône actuelle'),
                    'help' => $this->l('Icône affichée devant cette caractéristique sur les fiches produit. Formats recommandés : SVG ou PNG carré, 512 Ko max.'),
                    'accept' => '.svg,.png,.webp,.jpg,.jpeg,image/svg+xml,image/png,image/webp,image/jpeg',
                    'currentUrl' => $filename ? $this->buildIconUrl($filename) : '',
                    'currentFilename' => $filename,
                ],
            ]);
        }
    }

    public function hookDisplayFeatureForm(array $params)
    {
        $idFeature = $this->resolveFeatureId($params);

        $filename = $idFeature ? $this->getIconFilenameByFeature($idFeature) : '';

        $this->context->smarty->assign([
            'spoc_feature_icon_url' => $filename ? $this->buildIconUrl($filename) : '',
            'spoc_feature_icon_filename' => $filename,
        ]);

        return $this->display(__FILE__, 'views/templates/hook/feature_form.tpl');
    }

    public function hookFeatureForm(array $params)
    {
        return $this->hookDisplayFeatureForm($params);
    }

    public function hookDisplayFeaturePostProcess(array $params)
    {
        $this->handleFeatureIconSubmit($this->resolveFeatureId($params));
    }

    public function hookPostProcessFeature(array $params)
    {
        $this->hookDisplayFeaturePostProcess($params);
    }

    public function hookActionObjectFeatureAddAfter(array $params)
    {
        $this->handleFeatureObjectHook($params);
    }

    public function hookActionObjectFeatureUpdateAfter(array $params)
    {
        $this->handleFeatureObjectHook($params);
    }

    public function hookActionObjectFeatureDeleteAfter(array $params)
    {
        if (empty($params['object']) || empty($params['object']->id)) {
            return;
        }

        $this->deleteIcon((int) $params['object']->id);
    }

    public function hookActionAfterCreateFeatureFormHandler(array $params)
    {
        $this->handleFeatureIconSubmit($this->resolveFeatureId($params));
    }

    public function hookActionAfterUpdateFeatureFormHandler(array $params)
    {
        $this->handleFeatureIconSubmit($this->resolveFeatureId($params));
    }

    public static function getFeatureIconUrls()
    {
        if (self::$featureIconCache !== null) {
            return self::$featureIconCache;
        }

        self::$featureIconCache = [];

        if (!defined('_DB_PREFIX_')) {
            return self::$featureIconCache;
        }

        $module = Module::getInstanceByName('spocfeatureicons');

        if (!$module instanceof self || !$module->columnExists()) {
            return self::$featureIconCache;
        }

        $idLang = isset(Context::getContext()->language->id) ? (int) Context::getContext()->language->id : 0;
        $sql = 'SELECT f.`id_feature`, f.`' . pSQL(self::DB_FIELD) . '`, fl.`name`
            FROM `' . _DB_PREFIX_ . 'feature` f
            LEFT JOIN `' . _DB_PREFIX_ . 'feature_lang` fl
                ON (fl.`id_feature` = f.`id_feature` AND fl.`id_lang` = ' . (int) $idLang . ')
            WHERE f.`' . pSQL(self::DB_FIELD) . '` IS NOT NULL
              AND f.`' . pSQL(self::DB_FIELD) . '` != ""';

        try {
            $rows = Db::getInstance()->executeS($sql);
        } catch (Exception $exception) {
            return self::$featureIconCache;
        }

        if (!is_array($rows)) {
            return self::$featureIconCache;
        }

        foreach ($rows as $row) {
            $filename = basename((string) $row[self::DB_FIELD]);
            $idFeature = (int) $row['id_feature'];

            if ($filename && file_exists(_PS_IMG_DIR_ . self::UPLOAD_DIR . $filename)) {
                self::$featureIconCache[$idFeature] = [
                    'id_feature' => $idFeature,
                    'name' => isset($row['name']) ? (string) $row['name'] : '',
                    'url' => $module instanceof self ? $module->buildIconUrl($filename) : self::buildFallbackIconUrl($filename),
                    'filename' => $filename,
                ];
            }
        }

        return self::$featureIconCache;
    }

    private function handleFeatureObjectHook(array $params)
    {
        if (empty($params['object']) || empty($params['object']->id)) {
            return;
        }

        $this->handleFeatureIconSubmit((int) $params['object']->id);
    }

    private function resolveFeatureId(array $params = [])
    {
        $keys = ['id_feature', 'featureId', 'feature_id', 'id'];

        foreach ($keys as $key) {
            if (isset($params[$key]) && (int) $params[$key] > 0) {
                return (int) $params[$key];
            }

            $value = Tools::getValue($key);
            if ($value && (int) $value > 0) {
                return (int) $value;
            }
        }

        $requestUri = isset($_SERVER['REQUEST_URI']) ? (string) $_SERVER['REQUEST_URI'] : '';
        if (preg_match('#/sell/catalog/features/([0-9]+)(?:/|$)#', $requestUri, $matches)) {
            return (int) $matches[1];
        }

        return 0;
    }

    private function isFeatureAdminPage($controller, $requestUri)
    {
        $legacyController = Tools::strtolower((string) Tools::getValue('_legacy_controller'));

        return $controller === 'adminfeatures'
            || $legacyController === 'adminfeatures'
            || strpos($requestUri, '/sell/catalog/features') !== false
            || stripos($requestUri, 'controller=AdminFeatures') !== false;
    }

    private function isFeatureAdminFormPage($requestUri)
    {
        return (bool) preg_match('#/sell/catalog/features/(new|add|[0-9]+/edit)(?:/|$)#', $requestUri)
            || (bool) Tools::getValue('id_feature')
            || (bool) Tools::getValue('featureId')
            || Tools::isSubmit('addfeature')
            || Tools::isSubmit('updatefeature');
    }

    private function handleFeatureIconSubmit($idFeature)
    {
        if (!$idFeature || !$this->columnExists()) {
            return;
        }

        if (isset(self::$handledFeatureIconSubmits[(int) $idFeature])) {
            return;
        }

        self::$handledFeatureIconSubmits[(int) $idFeature] = true;

        $hasUpload = !empty($_FILES[self::UPLOAD_FIELD])
            && !empty($_FILES[self::UPLOAD_FIELD]['name'])
            && (int) $_FILES[self::UPLOAD_FIELD]['error'] !== UPLOAD_ERR_NO_FILE;

        if (Tools::getValue(self::DELETE_FIELD) && !$hasUpload) {
            $this->deleteIcon($idFeature);
        }

        if (!$hasUpload) {
            return;
        }

        $file = $_FILES[self::UPLOAD_FIELD];

        if ((int) $file['error'] !== UPLOAD_ERR_OK) {
            $this->addBackOfficeError($this->l('The feature icon could not be uploaded.'));
            return;
        }

        if ((int) $file['size'] > self::MAX_FILE_SIZE) {
            $this->addBackOfficeError($this->l('The feature icon must be smaller than 512 KB.'));
            return;
        }

        $extension = Tools::strtolower(pathinfo((string) $file['name'], PATHINFO_EXTENSION));
        $allowedExtensions = ['svg', 'png', 'webp', 'jpg', 'jpeg'];

        if (!in_array($extension, $allowedExtensions, true)) {
            $this->addBackOfficeError($this->l('Allowed feature icon formats are SVG, PNG, WebP, JPG and JPEG.'));
            return;
        }

        if (!$this->isValidUploadedIcon((string) $file['tmp_name'], $extension)) {
            $this->addBackOfficeError($this->l('The uploaded feature icon is not a valid image.'));
            return;
        }

        if (!$this->ensureUploadDirectory()) {
            $this->addBackOfficeError($this->l('The feature icon directory could not be created.'));
            return;
        }

        $filename = 'feature-' . (int) $idFeature . '.' . $extension;
        $destination = _PS_IMG_DIR_ . self::UPLOAD_DIR . $filename;

        $this->removeFeatureIconFiles($idFeature);

        if (!move_uploaded_file((string) $file['tmp_name'], $destination)) {
            $this->addBackOfficeError($this->l('The feature icon could not be saved.'));
            return;
        }

        @chmod($destination, 0644);

        Db::getInstance()->update(
            'feature',
            [self::DB_FIELD => pSQL($filename)],
            '`id_feature` = ' . (int) $idFeature
        );

        self::$featureIconCache = null;
    }

    private function installSql()
    {
        if ($this->columnExists()) {
            return true;
        }

        return Db::getInstance()->execute(
            'ALTER TABLE `' . _DB_PREFIX_ . 'feature`
                ADD `' . pSQL(self::DB_FIELD) . '` VARCHAR(255) NULL DEFAULT NULL'
        );
    }

    public function registerModuleHooks()
    {
        $hooks = [
            'displayHeader',
            'displayBackOfficeHeader',
            'actionAdminControllerSetMedia',
            'displayFeatureForm',
            'featureForm',
            'displayFeaturePostProcess',
            'postProcessFeature',
            'actionObjectFeatureAddAfter',
            'actionObjectFeatureUpdateAfter',
            'actionObjectFeatureDeleteAfter',
            'actionAfterCreateFeatureFormHandler',
            'actionAfterUpdateFeatureFormHandler',
        ];

        foreach ($hooks as $hook) {
            if (!$this->registerHook($hook)) {
                return false;
            }
        }

        return true;
    }

    private function ensureAdminHooks()
    {
        if (self::$adminHooksChecked) {
            return;
        }

        $this->registerModuleHooks();
        self::$adminHooksChecked = true;
    }

    private function uninstallSql()
    {
        if (!$this->columnExists()) {
            return true;
        }

        return Db::getInstance()->execute(
            'ALTER TABLE `' . _DB_PREFIX_ . 'feature`
                DROP `' . pSQL(self::DB_FIELD) . '`'
        );
    }

    private function columnExists()
    {
        $columns = Db::getInstance()->executeS(
            'SHOW COLUMNS FROM `' . _DB_PREFIX_ . 'feature` LIKE \'' . pSQL(self::DB_FIELD) . '\''
        );

        return !empty($columns);
    }

    private function ensureUploadDirectory()
    {
        $directory = _PS_IMG_DIR_ . self::UPLOAD_DIR;

        if (!is_dir($directory) && !mkdir($directory, 0755, true)) {
            return false;
        }

        $indexFile = $directory . 'index.php';

        if (!file_exists($indexFile) && @file_put_contents($indexFile, "<?php\n\nexit;\n") === false) {
            return false;
        }

        return is_writable($directory);
    }

    private function getIconFilenameByFeature($idFeature)
    {
        if (!$this->columnExists()) {
            return '';
        }

        return basename((string) Db::getInstance()->getValue(
            'SELECT `' . pSQL(self::DB_FIELD) . '`
            FROM `' . _DB_PREFIX_ . 'feature`
            WHERE `id_feature` = ' . (int) $idFeature
        ));
    }

    private function deleteIcon($idFeature)
    {
        $this->removeFeatureIconFiles($idFeature);

        if ($this->columnExists()) {
            Db::getInstance()->execute(
                'UPDATE `' . _DB_PREFIX_ . 'feature`
                SET `' . pSQL(self::DB_FIELD) . '` = NULL
                WHERE `id_feature` = ' . (int) $idFeature
            );
        }

        self::$featureIconCache = null;
    }

    private function removeFeatureIconFiles($idFeature)
    {
        $pattern = _PS_IMG_DIR_ . self::UPLOAD_DIR . 'feature-' . (int) $idFeature . '.*';
        $files = glob($pattern);

        if (!is_array($files)) {
            return;
        }

        foreach ($files as $file) {
            if (is_file($file)) {
                @unlink($file);
            }
        }
    }

    private function isValidUploadedIcon($tmpName, $extension)
    {
        if (!is_uploaded_file($tmpName)) {
            return false;
        }

        if ($extension === 'svg') {
            return $this->isValidSvg($tmpName);
        }

        return (bool) @getimagesize($tmpName);
    }

    private function isValidSvg($tmpName)
    {
        $content = file_get_contents($tmpName, false, null, 0, self::MAX_FILE_SIZE);

        if ($content === false || stripos($content, '<svg') === false) {
            return false;
        }

        return !preg_match('/<\s*(script|iframe|object|embed|foreignObject)\b/i', $content)
            && !preg_match('/\son[a-z]+\s*=/i', $content)
            && stripos($content, 'javascript:') === false
            && stripos($content, '<?php') === false;
    }

    private function addBackOfficeError($message)
    {
        if (isset($this->context->controller) && isset($this->context->controller->errors)) {
            $this->context->controller->errors[] = $message;
        }
    }

    private function buildIconUrl($filename)
    {
        if (isset($this->context->link)) {
            return $this->context->link->getMediaLink(_PS_IMG_ . self::UPLOAD_DIR . rawurlencode($filename));
        }

        return self::buildFallbackIconUrl($filename);
    }

    private static function buildFallbackIconUrl($filename)
    {
        return Tools::getShopDomainSsl(true) . __PS_BASE_URI__ . 'img/' . self::UPLOAD_DIR . rawurlencode($filename);
    }
}
