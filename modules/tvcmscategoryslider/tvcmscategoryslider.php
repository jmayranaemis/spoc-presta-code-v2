<?php
/**
 * 2007-2025 PrestaShop.
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/afl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to http://www.prestashop.com for more information.
 *
 *  @author    PrestaShop SA <contact@prestashop.com>
 *  @copyright 2007-2025 PrestaShop SA
 *  @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 *  International Registered Trademark & Property of PrestaShop SA
 */
if (!defined('_PS_VERSION_')) {
    exit;
}

include_once 'classes/tvcmscategoryslider_image_upload.class.php';
include_once 'classes/tvcmscategoryslider_status.class.php';

class TvcmsCategorySlider extends Module
{
    private $html = '';

    private $category_list = [];

    private $admin_obj = '';

    public $id_shop_group = '';

    public $id_shop = '';

    public function __construct()
    {
        $this->name = 'tvcmscategoryslider';
        $this->tab = 'front_office_features';
        $this->version = '4.0.4';
        $this->author = 'ThemeVolty';
        $this->need_instance = 0;
        $this->secure_key = Tools::encrypt($this->name);
        $this->bootstrap = true;

        parent::__construct();
        $this->displayName = $this->l('ThemeVolty - Categroy Slider');
        $this->description = $this->l('Display Category Slider in Front Side');

        $this->ps_versions_compliancy = ['min' => '1.7', 'max' => _PS_VERSION_];
        $this->module_key = '';

        $this->confirmUninstall = $this->l('Warning: all the data saved in your database will be deleted.'
            . ' Are you sure you want uninstall this module?');

        $this->id_shop_group = (int) Shop::getContextShopGroupID();
        $this->id_shop = (int) Context::getContext()->shop->id;
    }

    public function install()
    {
        // $this->createDefaultData();
        $this->createTable();
        $this->installTab();

        return parent::install()
            && $this->registerHook('displayBackOfficeHeader')
            && $this->registerHook('displayHeader')
            && $this->registerHook('displayHome')
            && $this->registerHook('displayContentWrapperTop')
            && $this->registerHook('displayWrapperTop');
        // && $this->registerHook('displayNavFullWidth');
    }

    public function installTab()
    {
        $response = true;

        // First check for parent tab
        $parentTabID = Tab::getIdFromClassName('AdminThemeVolty');

        if ($parentTabID) {
            $parentTab = new Tab($parentTabID);
        } else {
            $parentTab = new Tab();
            $parentTab->active = 1;
            $parentTab->name = [];
            $parentTab->class_name = 'AdminThemeVolty';
            foreach (Language::getLanguages() as $lang) {
                $parentTab->name[(int) $lang['id_lang']] = 'ThemeVolty Extension';
            }
            $parentTab->id_parent = 0;
            $parentTab->module = $this->name;
            $response &= $parentTab->add();
        }

        // Check for parent tab2
        $parentTab_2ID = Tab::getIdFromClassName('AdminThemeVoltyModules');
        if ($parentTab_2ID) {
            $parentTab_2 = new Tab($parentTab_2ID);
        } else {
            $parentTab_2 = new Tab();
            $parentTab_2->active = 1;
            $parentTab_2->name = [];
            $parentTab_2->class_name = 'AdminThemeVoltyModules';
            foreach (Language::getLanguages() as $lang) {
                $parentTab_2->name[(int) $lang['id_lang']] = 'ThemeVolty Configure';
            }
            $parentTab_2->id_parent = (int) $parentTab->id;
            $parentTab_2->module = $this->name;
            $response &= $parentTab_2->add();
        }

        // Created tab
        $tab = new Tab();
        $tab->active = 1;
        $tab->class_name = 'Admin' . $this->name;
        $tab->name = [];
        foreach (Language::getLanguages() as $lang) {
            $tab->name[(int) $lang['id_lang']] = 'Category Slider';
        }
        $tab->id_parent = (int) $parentTab_2->id;
        $tab->module = $this->name;
        $response &= $tab->add();

        return $response;
    }

    // Store Default Data Such As CreateVariable, CreateTable & Insert Data
    public function createDefaultData()
    {
        $this->reset();
        $num_of_data = 7;
        $this->createVariable();
        $this->createTable();
        $this->insertSampleData($num_of_data);
    }

    // Create Default Variable form Frist Form
    public function createVariable()
    {
        $result = [];
        $languages = Language::getLanguages();

        foreach ($languages as $lang) {
            $id_lang = (int) $lang['id_lang'];
            $result['TVCMSCATEGORY_SLIDER_TITLE'][$id_lang] = 'Featured Category';
            $result['TVCMSCATEGORY_SLIDER_SUB_DESCRIPTION'][$id_lang] = 'This is Show Short Description';
            $result['TVCMSCATEGORY_SLIDER_DESCRIPTION'][$id_lang] = 'Description';
            $result['TVCMSCATEGORY_SLIDER_IMG'][$id_lang] = 'demo_title.jpg';
        }

        Configuration::updateValue('TVCMSCATEGORY_SLIDER_TITLE', $result['TVCMSCATEGORY_SLIDER_TITLE']);
        Configuration::updateValue('TVCMSCATEGORY_SLIDER_SUB_DESCRIPTION', $result['TVCMSCATEGORY_SLIDER_SUB_DESCRIPTION']);
        Configuration::updateValue('TVCMSCATEGORY_SLIDER_DESCRIPTION', $result['TVCMSCATEGORY_SLIDER_DESCRIPTION']);
        Configuration::updateValue('TVCMSCATEGORY_SLIDER_IMG', $result['TVCMSCATEGORY_SLIDER_IMG']);
    }

    // Create Table For Second Form
    public function createTable()
    {
        $create_table = [];
        $create_table[] = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'tvcmscategory_slider` (
                        `id_tvcmscategory_slider` int(11) AUTO_INCREMENT PRIMARY KEY,
                        `id_category` int(11),
                        `id_shop_group` int(11),
                        `id_shop` int(11),
                        `position` int(11),
                        `image` VARCHAR(100),
                        `width` int(30),
                        `height` int(30),
                        `status` varchar(3)
                    ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8;';

        $create_table[] = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'tvcmscategory_slider_lang` (
                        `id_tvcmscategory_slider_lang` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                        `id_tvcmscategory_slider` INT NOT NULL,
                        `id_category` INT,
                        `id_shop_group` int(11),
                        `id_shop` int(11),
                        `id_lang` INT NOT NULL,
                        `title` VARCHAR(255),
                        `short_description` TEXT
                    ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8;';

        foreach ($create_table as $table) {
            Db::getInstance()->execute($table);
        }
    }

    // Insert Semple Data Form Second Form
    public function insertSampleData($num_of_data)
    {
        $data = [];
        $category = $this->getAllCategory();

        for ($i = 1; $i <= (int) $num_of_data; ++$i) {
            $width = 177;
            $height = 238;

            $image_path = dirname(__FILE__) . '/views/img/demo_img_' . (int) $i . '.png';
            if (file_exists($image_path)) {
                $imagedata = @getimagesize($image_path);
                if (!empty($imagedata[0]) && !empty($imagedata[1])) {
                    $width = (int) $imagedata[0];
                    $height = (int) $imagedata[1];
                }
            }

            if (isset($category[$i]['id_category'])) {
                $id_category = (int) $category[$i]['id_category'];

                $data[] = 'INSERT INTO `' . _DB_PREFIX_ . 'tvcmscategory_slider`
                            SET 
                                id_tvcmscategory_slider = ' . (int) $i . ',
                                id_category = ' . (int) $id_category . ',
                                `id_shop_group` = ' . (int) $this->id_shop_group . ',
                                `id_shop` = ' . (int) $this->id_shop . ',
                                image = \'demo_img_' . (int) $i . '.png\',
                                `width` = ' . (int) $width . ',
                                `height` = ' . (int) $height . ',
                                status = \'1\'';

                $languages = Language::getLanguages();
                foreach ($languages as $lang) {
                    $data[] = 'INSERT INTO `' . _DB_PREFIX_ . 'tvcmscategory_slider_lang`
                            SET 
                                id_tvcmscategory_slider_lang = NULL,
                                id_tvcmscategory_slider = ' . (int) $i . ',
                                id_category = ' . (int) $id_category . ',
                                `id_shop_group` = ' . (int) $this->id_shop_group . ',
                                `id_shop` = ' . (int) $this->id_shop . ',
                                id_lang = ' . (int) $lang['id_lang'] . ',
                                title = \'Title ' . (int) $i . '\',
                                short_description = \'Short Description ' . (int) $i . '\'';
                }
            } else {
                $data[] = 'INSERT INTO `' . _DB_PREFIX_ . 'tvcmscategory_slider`
                            SET 
                                id_tvcmscategory_slider = ' . (int) $i . ',
                                id_category = 1,
                                `id_shop_group` = ' . (int) $this->id_shop_group . ',
                                `id_shop` = ' . (int) $this->id_shop . ',
                                image = \'demo_img_' . (int) $i . '.png\',
                                `width` = ' . (int) $width . ',
                                `height` = ' . (int) $height . ',
                                status = \'0\'';

                $languages = Language::getLanguages();
                foreach ($languages as $lang) {
                    $data[] = 'INSERT INTO `' . _DB_PREFIX_ . 'tvcmscategory_slider_lang`
                            SET 
                                id_tvcmscategory_slider_lang = NULL,
                                id_tvcmscategory_slider = ' . (int) $i . ',
                                id_category = 1,
                                `id_shop_group` = ' . (int) $this->id_shop_group . ',
                                `id_shop` = ' . (int) $this->id_shop . ',
                                id_lang = ' . (int) $lang['id_lang'] . ',
                                title = \'Title ' . (int) $i . '\',
                                short_description = \'Short Description ' . (int) $i . '\'';
                }
            }
        }

        foreach ($data as $query) {
            Db::getInstance()->execute($query);
        }
    }

    public function maxId()
    {
        $select_data = 'SELECT MAX(id_tvcmscategory_slider) as max_id FROM `' . _DB_PREFIX_ . 'tvcmscategory_slider`';
        $ans = Db::getInstance()->executeS($select_data);

        return isset($ans[0]['max_id']) ? (int) $ans[0]['max_id'] : 0;
    }

    // Select All Category id From Table
    public function selectAllIdFromTable()
    {
        $select_data = 'SELECT id_tvcmscategory_slider FROM `' . _DB_PREFIX_ . 'tvcmscategory_slider`'
             . ' WHERE `id_shop_group` = ' . (int) $this->id_shop_group . ' AND `id_shop` = ' . (int) $this->id_shop
             . ' ORDER BY id_tvcmscategory_slider;';

        $ans = Db::getInstance()->executeS($select_data);
        $final_ans = [];

        foreach ($ans as $a) {
            if (isset($a['id_tvcmscategory_slider'])) {
                $final_ans[] = (int) $a['id_tvcmscategory_slider'];
            }
        }

        return $final_ans;
    }

    // Select All Language By id From Table
    public function selectAllLangIdById($id_tvcmscategory_slider)
    {
        $select_data = 'SELECT 
                            id_lang 
                        FROM 
                            `' . _DB_PREFIX_ . 'tvcmscategory_slider_lang` 
                        WHERE 
                            `id_shop_group` = ' . (int) $this->id_shop_group . '
                            AND `id_shop` = ' . (int) $this->id_shop . '
                            AND id_tvcmscategory_slider = ' . (int) $id_tvcmscategory_slider;

        $ans = Db::getInstance()->executeS($select_data);
        $return = [];

        foreach ($ans as $a) {
            $return[] = (int) $a['id_lang'];
        }

        return $return;
    }

    // Insert & Update Data Which Customer Add.
    public function insertData($data)
    {
        $insert_data = [];
        $id_category = isset($data['id_category']) ? (int) $data['id_category'] : 0;
        $status = !empty($data['status']) ? 1 : 0;
        $image = isset($data['image']) ? pSQL($data['image']) : '';
        $width = isset($data['width']) ? (int) $data['width'] : 0;
        $height = isset($data['height']) ? (int) $data['height'] : 0;

        if (!empty($data['id'])) {
            $id = (int) $data['id'];

            $insert_data[] = 'UPDATE `' . _DB_PREFIX_ . 'tvcmscategory_slider`
                        SET 
                            id_category = ' . (int) $id_category . ',
                            image = \'' . $image . '\',
                            width = ' . (int) $width . ',
                            height = ' . (int) $height . ',
                            status = ' . (int) $status . '
                        WHERE
                            `id_shop_group` = ' . (int) $this->id_shop_group . '
                            AND `id_shop` = ' . (int) $this->id_shop . '
                            AND `id_tvcmscategory_slider` = ' . (int) $id . ';';

            $result = $this->selectAllLangIdById($id);

            $languages = Language::getLanguages();
            foreach ($languages as $lang) {
                $id_lang = (int) $lang['id_lang'];

                $custom_title = isset($data['lang_info'][$id_lang]['custom_title'])
                    ? pSQL($data['lang_info'][$id_lang]['custom_title'])
                    : '';

                $short_description = isset($data['lang_info'][$id_lang]['short_description'])
                    ? pSQL($data['lang_info'][$id_lang]['short_description'])
                    : '';

                if (in_array($id_lang, $result)) {
                    $insert_data[] = 'UPDATE `' . _DB_PREFIX_ . 'tvcmscategory_slider_lang`
                            SET 
                                id_category = ' . (int) $id_category . ',
                                id_lang = ' . (int) $id_lang . ',
                                title = \'' . $custom_title . '\',
                                short_description = \'' . $short_description . '\'
                            WHERE
                                    `id_shop_group` = ' . (int) $this->id_shop_group . '
                                AND 
                                    `id_shop` = ' . (int) $this->id_shop . '
                                AND
                                    `id_tvcmscategory_slider` = ' . (int) $id . '
                                AND
                                    `id_lang` = ' . (int) $id_lang . ';';
                } else {
                    $insert_data[] = 'INSERT INTO `' . _DB_PREFIX_ . 'tvcmscategory_slider_lang`
                        SET 
                            id_tvcmscategory_slider_lang = NULL,
                            id_tvcmscategory_slider = ' . (int) $id . ',
                            id_category = ' . (int) $id_category . ',
                            `id_shop_group` = ' . (int) $this->id_shop_group . ',
                            `id_shop` = ' . (int) $this->id_shop . ',
                            id_lang = ' . (int) $id_lang . ',
                            title = \'' . $custom_title . '\',
                            short_description = \'' . $short_description . '\';';
                }
            }
        } else {
            $max_id = $this->maxId();
            $new_id = (int) $max_id + 1;

            $insert_data[] = 'INSERT INTO `' . _DB_PREFIX_ . 'tvcmscategory_slider`
                        SET 
                            id_tvcmscategory_slider = ' . (int) $new_id . ',
                            id_category = ' . (int) $id_category . ',
                            position = ' . (int) $new_id . ',
                            `id_shop_group` = ' . (int) $this->id_shop_group . ',
                            `id_shop` = ' . (int) $this->id_shop . ',
                            image = \'' . $image . '\',
                            width = ' . (int) $width . ',
                            height = ' . (int) $height . ',
                            status = ' . (int) $status . ';';

            $languages = Language::getLanguages();
            foreach ($languages as $lang) {
                $id_lang = (int) $lang['id_lang'];

                $custom_title = isset($data['lang_info'][$id_lang]['custom_title'])
                    ? pSQL($data['lang_info'][$id_lang]['custom_title'])
                    : '';

                $short_description = isset($data['lang_info'][$id_lang]['short_description'])
                    ? pSQL($data['lang_info'][$id_lang]['short_description'])
                    : '';

                $insert_data[] = 'INSERT INTO `' . _DB_PREFIX_ . 'tvcmscategory_slider_lang`
                        SET 
                            id_tvcmscategory_slider_lang = NULL,
                            id_tvcmscategory_slider = ' . (int) $new_id . ',
                            id_category = ' . (int) $id_category . ',
                            `id_shop_group` = ' . (int) $this->id_shop_group . ',
                            `id_shop` = ' . (int) $this->id_shop . ',
                            id_lang = ' . (int) $id_lang . ',
                            title = \'' . $custom_title . '\',
                            short_description = \'' . $short_description . '\';';
            }
        }

        foreach ($insert_data as $query) {
            Db::getInstance()->execute($query);
        }
    }

    private function compareCategoryNames($nameA, $nameB)
    {
        $nameA = trim((string) $nameA);
        $nameB = trim((string) $nameB);

        static $collator = null;

        if (null === $collator && class_exists('Collator')) {
            $collator = new Collator('fr_FR');
        }

        if ($collator instanceof Collator) {
            $result = $collator->compare($nameA, $nameB);
            if (false !== $result) {
                return $result;
            }
        }

        if (function_exists('mb_strtolower')) {
            $nameA = mb_strtolower($nameA, 'UTF-8');
            $nameB = mb_strtolower($nameB, 'UTF-8');
        }

        return strnatcasecmp($nameA, $nameB);
    }

    private function sortCategoryRowsByName($categories)
    {
        if (!is_array($categories) || empty($categories)) {
            return [];
        }

        usort($categories, function ($a, $b) {
            $nameA = isset($a['name']) ? $a['name'] : '';
            $nameB = isset($b['name']) ? $b['name'] : '';

            return $this->compareCategoryNames($nameA, $nameB);
        });

        return $categories;
    }

    private function sortCategoryNameMap($categories)
    {
        if (!is_array($categories) || empty($categories)) {
            return [];
        }

        uasort($categories, function ($a, $b) {
            return $this->compareCategoryNames($a, $b);
        });

        return $categories;
    }

    private function isSelectableCategory($id_category)
    {
        $id_category = (int) $id_category;

        if ($id_category <= 0) {
            return false;
        }

        $categories = $this->getAllCategory();

        foreach ($categories as $category) {
            if (isset($category['id_category']) && (int) $category['id_category'] === $id_category) {
                return true;
            }
        }

        return false;
    }

    // Get all Category Which Key is Id And Value is Category Name
    public function getAllCategory()
    {
        $category = Category::getAllCategoriesName();
        $all_category_id = [];
        $i = 0;

        unset($category[0]);
        unset($category[1]);

        foreach ($category as $cat) {
            if (!isset($cat['id_category']) || !isset($cat['name'])) {
                continue;
            }

            $id_category = (int) $cat['id_category'];
            $name = trim((string) $cat['name']);

            if ($id_category <= 0 || '' === $name) {
                continue;
            }

            $all_category_id[$i]['id_category'] = $id_category;
            $all_category_id[$i]['name'] = $name;
            ++$i;
        }

        return $this->sortCategoryRowsByName($all_category_id);
    }

    // Show Admin Data in Table
    public function showAdminData()
    {
        $result = [];
        $return_data = [];
        $default_lang_id = (int) $this->context->language->id;

        $select_data = 'SELECT * FROM `' . _DB_PREFIX_ . 'tvcmscategory_slider`'
             . ' WHERE `id_shop_group` = ' . (int) $this->id_shop_group . ' AND `id_shop` = ' . (int) $this->id_shop
             . ' ORDER BY `position`;';

        $result['tvcmscategory_slider'] = Db::getInstance()->executeS($select_data);

        $select_data = 'SELECT * FROM `' . _DB_PREFIX_ . 'tvcmscategory_slider_lang`'
             . ' WHERE `id_shop_group` = ' . (int) $this->id_shop_group . ' AND `id_shop` = ' . (int) $this->id_shop . ';';

        $result['tvcmscategory_slider_lang'] = Db::getInstance()->executeS($select_data);

        foreach ($result['tvcmscategory_slider'] as $key => $data) {
            $return_data[$key]['id'] = (int) $data['id_tvcmscategory_slider'];
            $id = (int) $data['id_tvcmscategory_slider'];

            foreach ($result['tvcmscategory_slider_lang'] as $lang) {
                if ($default_lang_id == (int) $lang['id_lang'] && $id == (int) $lang['id_tvcmscategory_slider']) {
                    $return_data[$key]['id_lang'] = (int) $lang['id_lang'];
                    $return_data[$key]['title'] = $lang['title'];
                    $return_data[$key]['short_description'] = $lang['short_description'];
                }
            }

            $return_data[$key]['id_category'] = (int) $data['id_category'];
            $return_data[$key]['image'] = $data['image'];
            $return_data[$key]['width'] = (int) $data['width'];
            $return_data[$key]['height'] = (int) $data['height'];
            $return_data[$key]['status'] = (int) $data['status'];
        }

        return $return_data;
    }

    // Show Front Side Data
    public function showData($id = null)
    {
        $result = [];
        $return_data = [];

        $select_data = '';
        $select_data .= 'SELECT * FROM `' . _DB_PREFIX_ . 'tvcmscategory_slider` 
                WHERE 
                `id_shop_group` = ' . (int) $this->id_shop_group
                 . ' AND `id_shop` = ' . (int) $this->id_shop;

        if ($id) {
            $select_data .= ' AND `id_tvcmscategory_slider` = ' . (int) $id;
        } else {
            $select_data .= ' ORDER BY `position`';
        }

        $result['tvcmscategory_slider'] = Db::getInstance()->executeS($select_data);

        $select_data = '';
        $select_data .= 'SELECT * FROM `' . _DB_PREFIX_ . 'tvcmscategory_slider_lang`'
             . ' WHERE `id_shop_group` = ' . (int) $this->id_shop_group . ' AND `id_shop` = ' . (int) $this->id_shop;

        if ($id) {
            $select_data .= ' AND id_tvcmscategory_slider = ' . (int) $id;
        }

        $result['tvcmscategory_slider_lang'] = Db::getInstance()->executeS($select_data);

        foreach ($result['tvcmscategory_slider'] as $key => $data) {
            $return_data[$key]['id'] = (int) $data['id_tvcmscategory_slider'];

            foreach ($result['tvcmscategory_slider_lang'] as $lang) {
                if ((int) $data['id_tvcmscategory_slider'] == (int) $lang['id_tvcmscategory_slider']) {
                    $id_lang = (int) $lang['id_lang'];
                    $return_data[$key]['lang_info'][$id_lang]['id_lang'] = $id_lang;
                    $return_data[$key]['lang_info'][$id_lang]['title'] = $lang['title'];
                    $return_data[$key]['lang_info'][$id_lang]['short_description'] = $lang['short_description'];
                }
            }

            $return_data[$key]['id_category'] = (int) $data['id_category'];
            $return_data[$key]['image'] = $data['image'];
            $return_data[$key]['width'] = (int) $data['width'];
            $return_data[$key]['height'] = (int) $data['height'];
            $return_data[$key]['status'] = (int) $data['status'];
        }

        return $return_data;
    }

    public function showFrontData()
    {
        $cookie = Context::getContext()->cookie;
        $id_lang = (int) $cookie->id_lang;

        $select_data = '
            SELECT 
                mainTable.id_tvcmscategory_slider AS code,
                mainTable.id_category,
                mainTable.image,
                mainTable.width,
                mainTable.height,
                subTable.title,
                subTable.short_description
            FROM 
                `' . _DB_PREFIX_ . 'tvcmscategory_slider` mainTable
            LEFT JOIN
                `' . _DB_PREFIX_ . 'tvcmscategory_slider_lang` subTable
            ON
                mainTable.id_tvcmscategory_slider = subTable.id_tvcmscategory_slider
            WHERE 
                mainTable.id_shop_group = ' . (int) $this->id_shop_group . ' 
            AND 
                mainTable.id_shop = ' . (int) $this->id_shop . '
            AND 
                mainTable.status = 1
            AND
                subTable.id_lang = ' . (int) $id_lang . '
            ORDER BY mainTable.`position`';

        $result = Db::getInstance()->executeS($select_data);
        $result_data = [];

        if (!empty($result)) {
            $result_data = $result;
        }

        return $result_data;
    }

    public function getAllCategoryByIdsKey()
    {
        $category = Category::getAllCategoriesName();
        $all_category_id = [];

        foreach ($category as $cat) {
            if (!isset($cat['id_category']) || !isset($cat['name'])) {
                continue;
            }

            $id_category = (int) $cat['id_category'];
            $name = trim((string) $cat['name']);

            if ($id_category <= 0 || '' === $name) {
                continue;
            }

            $all_category_id[$id_category] = $name;
        }

        return $this->sortCategoryNameMap($all_category_id);
    }

    public function uninstall()
    {
        $this->uninstallTab();
        $this->deleteVariable();
        $this->deleteTable();

        return parent::uninstall();
    }

    // Delete All Variable of Frist Form
    public function deleteVariable()
    {
        Configuration::deleteByName('TVCMSCATEGORY_SLIDER_TITLE');
        Configuration::deleteByName('TVCMSCATEGORY_SLIDER_SUB_DESCRIPTION');
        Configuration::deleteByName('TVCMSCATEGORY_SLIDER_DESCRIPTION');
        Configuration::deleteByName('TVCMSCATEGORY_SLIDER_IMG');
    }

    // Delete Record by id Form Table
    public function removeRecord($id)
    {
        $id = (int) $id;

        if ($id <= 0) {
            return;
        }

        $this->removeImage($id);

        $delete_data = [];
        $delete_data[] = 'DELETE FROM `' . _DB_PREFIX_ . 'tvcmscategory_slider`
            WHERE 
                    `id_shop_group` = ' . (int) $this->id_shop_group . '
                AND 
                    `id_shop` = ' . (int) $this->id_shop . ' 
                AND 
                    `id_tvcmscategory_slider` = ' . (int) $id;

        $delete_data[] = 'DELETE FROM `' . _DB_PREFIX_ . 'tvcmscategory_slider_lang` 
            WHERE 
                    `id_shop_group` = ' . (int) $this->id_shop_group . '
                AND 
                    `id_shop` = ' . (int) $this->id_shop . ' 
                AND 
                    id_tvcmscategory_slider = ' . (int) $id;

        foreach ($delete_data as $data) {
            Db::getInstance()->execute($data);
        }
    }

    // Delete All table
    public function deleteTable()
    {
        $delete_table = [];
        $delete_table[] = 'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'tvcmscategory_slider`';
        $delete_table[] = 'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'tvcmscategory_slider_lang`';

        foreach ($delete_table as $table) {
            Db::getInstance()->execute($table);
        }
    }

    public function uninstallTab()
    {
        $id_tab = (int) Tab::getIdFromClassName('Admin' . $this->name);

        if ($id_tab > 0) {
            $tab = new Tab($id_tab);
            $tab->delete();
        }

        return true;
    }

    public function removeImage($id)
    {
        $id = (int) $id;

        if ($id <= 0) {
            return;
        }

        $result = $this->showData($id);

        if (empty($result[0]['image'])) {
            return;
        }

        $image = basename((string) $result[0]['image']);

        if ('' === $image) {
            return;
        }

        $res = preg_match('/^demo_img_.*$/', $image);
        $image_path = dirname(__FILE__) . '/views/img/' . $image;

        if (file_exists($image_path) && '1' != $res) {
            @unlink($image_path);
        }
    }

    public function reset()
    {
        $trn_tbl = [];
        $trn_tbl[] = 'TRUNCATE `' . _DB_PREFIX_ . 'tvcmscategory_slider`';
        $trn_tbl[] = 'TRUNCATE `' . _DB_PREFIX_ . 'tvcmscategory_slider_lang`';

        foreach ($trn_tbl as $table) {
            Db::getInstance()->execute($table);
        }
    }

    public function getContent()
    {
        $useSSL = (isset($this->ssl) && $this->ssl && Configuration::get('PS_SSL_ENABLED')) || Tools::usingSecureMode() ? true : false;
        $protocol_content = $useSSL ? 'https://' : 'http://';
        $baseDir = $protocol_content . Tools::getHttpHost() . __PS_BASE_URI__;
        $link = PS_ADMIN_DIR;

        if (Tools::substr(strrchr($link, '/'), 1)) {
            $admin_folder = Tools::substr(strrchr($link, '/'), 1);
        } else {
            $admin_folder = Tools::substr(strrchr($link, "\'"), 1);
        }

        $static_token = Tools::getAdminToken('AdminModules' . (int) Tab::getIdFromClassName('AdminModules') . (int) $this->context->employee->id);
        $url_Catsampleupgrade = $baseDir . $admin_folder . '/index.php?controller=AdminModules&configure=' . $this->name . '&tab_module=front_office_features&module_name=' . $this->name . '&token=' . $static_token;
        $this->context->smarty->assign('tvurlCatsampleupgrade', $url_Catsampleupgrade);

        if (Tools::isSubmit('submitTvcmsSampleinstall')) {
            $this->createDefaultData();
        }

        $languages = Language::getLanguages();
        $message = '';
        $result = [];

        if (Tools::getValue('action')) {
            $action = Tools::getValue('action');
            $id = (int) Tools::getValue('id');

            if ('remove' == $action && $id > 0) {
                $this->removeRecord($id);
                $message .= $this->displayConfirmation($this->l('Record is Deleted.'));
            }
        }

        if (Tools::isSubmit('submitTvcmsCategoryForm')) {
            $old_file = '';
            $old_width = 0;
            $old_height = 0;
            $no_image_selected = false;

            $result['id'] = '';
            $result['image'] = '';
            $result['width'] = 0;
            $result['height'] = 0;

            if (Tools::getValue('id')) {
                $id = (int) Tools::getValue('id');
                $result['id'] = $id;
                $data = $this->showData($id);

                if (!empty($data[0])) {
                    $old_file = isset($data[0]['image']) ? $data[0]['image'] : '';
                    $old_width = isset($data[0]['width']) ? (int) $data[0]['width'] : 0;
                    $old_height = isset($data[0]['height']) ? (int) $data[0]['height'] : 0;
                }

                $result['image'] = $old_file;
                $result['width'] = $old_width;
                $result['height'] = $old_height;
            }

            $tvcms_obj = new TvcmsCategorySliderStatus();
            $show_fields = $tvcms_obj->fieldStatusInformation();

            if ($show_fields['image']) {
                $this->obj_image = new TvcmsCategorySliderImageUpload();

                if (!empty($_FILES['image']['name'])) {
                    $new_file = $_FILES['image'];
                    $ans = $this->obj_image->imageUploading($new_file, $old_file);

                    if (!empty($ans['success'])) {
                        $result['image'] = isset($ans['name']) ? $ans['name'] : '';
                        $result['width'] = isset($ans['width']) ? (int) $ans['width'] : 0;
                        $result['height'] = isset($ans['height']) ? (int) $ans['height'] : 0;
                    } else {
                        $message .= isset($ans['error']) ? $ans['error'] : $this->displayError($this->l('Image upload error.'));
                        $result['image'] = $old_file;
                        $result['width'] = $old_width;
                        $result['height'] = $old_height;

                        if (!Tools::getValue('id')) {
                            $no_image_selected = true;
                        }
                    }
                } else {
                    $result['image'] = $old_file;
                    $result['width'] = $old_width;
                    $result['height'] = $old_height;

                    if (!Tools::getValue('id')) {
                        $message .= $this->displayError($this->l('Please Select Image.'));
                        $no_image_selected = true;
                    }
                }
            }

            if (!$no_image_selected) {
                foreach ($languages as $lang) {
                    $id_lang = (int) $lang['id_lang'];

                    $tmp = Tools::getValue('custom_title_' . $id_lang);
                    $result['lang_info'][$id_lang]['custom_title'] = $tmp;

                    $tmp = Tools::getValue('short_description_' . $id_lang);
                    $result['lang_info'][$id_lang]['short_description'] = $tmp;
                }

                $result['id_category'] = (int) Tools::getValue('id_category');
                $result['status'] = !empty(Tools::getValue('status')) ? 1 : 0;

                if ($result['id_category'] <= 0 || !$this->isSelectableCategory($result['id_category'])) {
                    $message .= $this->displayError($this->l('Please select valid category.'));
                } else {
                    $this->insertData($result);
                    $message .= $this->displayConfirmation($this->l('Record is save successfully.'));
                }

                $this->clearCustomSmartyCache('tvcmscategoryslider_display_home.tpl');
            }
        }

        if (Tools::isSubmit('submitTvcmsCategoryTitle')) {
            foreach ($languages as $lang) {
                $id_lang = (int) $lang['id_lang'];
                $this->obj_image = new TvcmsCategorySliderImageUpload();

                if (!empty($_FILES['TVCMSCATEGORY_SLIDER_IMG_' . $id_lang]['name'])) {
                    $old_file = Configuration::get('TVCMSCATEGORY_SLIDER_IMG', $id_lang);
                    $new_file = $_FILES['TVCMSCATEGORY_SLIDER_IMG_' . $id_lang];
                    $ans = $this->obj_image->imageUploading($new_file, $old_file);

                    if (!empty($ans['success'])) {
                        $result['TVCMSCATEGORY_SLIDER_IMG'][$id_lang] = isset($ans['name']) ? $ans['name'] : '';
                    } else {
                        $message .= isset($ans['error']) ? $ans['error'] : $this->displayError($this->l('Image upload error.'));
                        $result['TVCMSCATEGORY_SLIDER_IMG'][$id_lang] = $old_file;
                    }
                } else {
                    $old_file = Configuration::get('TVCMSCATEGORY_SLIDER_IMG', $id_lang);
                    $result['TVCMSCATEGORY_SLIDER_IMG'][$id_lang] = $old_file;
                }

                $tmp = Tools::getValue('TVCMSCATEGORY_SLIDER_TITLE_' . $id_lang);
                $result['TVCMSCATEGORY_SLIDER_TITLE'][$id_lang] = $tmp;

                $tmp = Tools::getValue('TVCMSCATEGORY_SLIDER_SUB_DESCRIPTION_' . $id_lang);
                $result['TVCMSCATEGORY_SLIDER_SUB_DESCRIPTION'][$id_lang] = $tmp;

                $tmp = Tools::getValue('TVCMSCATEGORY_SLIDER_DESCRIPTION_' . $id_lang);
                $result['TVCMSCATEGORY_SLIDER_DESCRIPTION'][$id_lang] = $tmp;
            }

            Configuration::updateValue('TVCMSCATEGORY_SLIDER_TITLE', $result['TVCMSCATEGORY_SLIDER_TITLE']);
            Configuration::updateValue('TVCMSCATEGORY_SLIDER_SUB_DESCRIPTION', $result['TVCMSCATEGORY_SLIDER_SUB_DESCRIPTION']);
            Configuration::updateValue('TVCMSCATEGORY_SLIDER_DESCRIPTION', $result['TVCMSCATEGORY_SLIDER_DESCRIPTION']);
            Configuration::updateValue('TVCMSCATEGORY_SLIDER_IMG', $result['TVCMSCATEGORY_SLIDER_IMG']);

            $message .= $this->displayConfirmation($this->l('Category Slider Title Updated.'));
        }

        $this->html .= $message;
        $this->html .= $this->renderForm();
        $this->html .= $this->showRecord();

        return $this->html;
    }

    public function clearCustomSmartyCache($cache_id)
    {
        if (Cache::isStored($cache_id)) {
            Cache::clean($cache_id);
        }
    }

    // Show All Admin data in getContent Function
    public function showRecord()
    {
        $array_list = $this->showAdminData();
        $category_list = $this->getAllCategoryByIdsKey();

        $tvcms_obj = new TvcmsCategorySliderStatus();
        $show_fields = $tvcms_obj->fieldStatusInformation();
        $default_lang_id = (int) $this->context->language->id;

        $this->context->smarty->assign('array_list', $array_list);
        $this->context->smarty->assign('category_list', $category_list);
        $this->context->smarty->assign('show_fields', $show_fields);
        $this->context->smarty->assign('default_lang_id', $default_lang_id);

        return $this->display(__FILE__, 'views/templates/admin/display_manage.tpl');
    }

    public function getConfigFormValues()
    {
        $cookie = Context::getContext()->cookie;
        $id_lang = (int) $cookie->id_lang;
        $this->context->smarty->assign('id_lang', $id_lang);

        $fields = [];
        $languages = Language::getLanguages();

        // Frist Form Information
        foreach ($languages as $lang) {
            $id_lang_item = (int) $lang['id_lang'];

            $fields['TVCMSCATEGORY_SLIDER_TITLE'][$id_lang_item] = Configuration::get('TVCMSCATEGORY_SLIDER_TITLE', $id_lang_item);
            $fields['TVCMSCATEGORY_SLIDER_SUB_DESCRIPTION'][$id_lang_item] = Configuration::get('TVCMSCATEGORY_SLIDER_SUB_DESCRIPTION', $id_lang_item);
            $fields['TVCMSCATEGORY_SLIDER_DESCRIPTION'][$id_lang_item] = Configuration::get('TVCMSCATEGORY_SLIDER_DESCRIPTION', $id_lang_item);
            $fields['TVCMSCATEGORY_SLIDER_IMG'][$id_lang_item] = Configuration::get('TVCMSCATEGORY_SLIDER_IMG', $id_lang_item);
        }

        $path = _MODULE_DIR_ . $this->name . '/views/img/';
        $this->context->smarty->assign('path', $path);

        $all_category = $this->getAllCategory();
        $this->context->smarty->assign('all_category', $all_category);

        // Second Form Information
        $fields['id'] = '';

        foreach ($languages as $lang) {
            $id_lang_item = (int) $lang['id_lang'];
            $fields['custom_title'][$id_lang_item] = '';
            $fields['short_description'][$id_lang_item] = '';
        }

        $fields['image'] = '';
        $fields['status'] = 1;
        $this->context->smarty->assign('id_category_select', '0');

        if ('edit' == Tools::getValue('action')) {
            $id = (int) Tools::getValue('id');
            $data = $this->showData($id);

            if (!empty($data[0])) {
                $data = $data[0];
                $fields['id'] = $id;

                foreach ($languages as $lang) {
                    $id_lang_item = (int) $lang['id_lang'];

                    $fields['custom_title'][$id_lang_item] = isset($data['lang_info'][$id_lang_item]['title'])
                        ? $data['lang_info'][$id_lang_item]['title']
                        : '';

                    $fields['short_description'][$id_lang_item] = isset($data['lang_info'][$id_lang_item]['short_description'])
                        ? $data['lang_info'][$id_lang_item]['short_description']
                        : '';
                }

                $fields['status'] = isset($data['status']) ? (int) $data['status'] : 1;
                $fields['image'] = isset($data['image']) ? $data['image'] : '';

                $this->context->smarty->assign('id_category_select', isset($data['id_category']) ? (int) $data['id_category'] : 0);
            }
        }

        return $fields;
    }

    public function renderForm()
    {
        $helper = new HelperForm();

        $helper->show_toolbar = false;
        $helper->table = $this->table;
        $helper->module = $this;
        $helper->default_form_language = (int) $this->context->language->id;
        $helper->allow_employee_form_lang = Configuration::get('PS_BO_ALLOW_EMPLOYEE_FORM_LANG', 0);

        $helper->identifier = $this->identifier;
        $helper->currentIndex = $this->context->link->getAdminLink('AdminModules', false)
             . '&configure=' . $this->name . '&tab_module=' . $this->tab . '&module_name=' . $this->name;
        $helper->token = Tools::getAdminTokenLite('AdminModules');
        $helper->show_cancel_button = true;

        $module = 'tvcmscategoryslider';
        $url = 'index.php?controller=AdminModules&configure=' . $module . '&token=' . Tools::getAdminTokenLite('AdminModules');

        $helper->back_url = $url;

        $helper->tpl_vars = [
            'fields_value' => $this->getConfigFormValues(),
            'languages' => $this->context->controller->getLanguages(),
            'id_language' => (int) $this->context->language->id,
        ];

        $form = [];
        $tvcms_obj = new TvcmsCategorySliderStatus();
        $show_fields = $tvcms_obj->fieldStatusInformation();

        if ($show_fields['main_status']) {
            $form[] = $this->tvcmsCategoryTitle();
        }

        if ($show_fields['record_form']) {
            $form[] = $this->tvcmsCategoryForm();
        }

        return $helper->generateForm($form);
    }

    protected function tvcmsCategoryForm()
    {
        $input = [];
        $tvcms_obj = new TvcmsCategorySliderStatus();
        $show_fields = $tvcms_obj->fieldStatusInformation();

        if (Tools::getValue('action')) {
            if ('edit' == Tools::getValue('action')) {
                $input[] = [
                        'type' => 'hidden',
                        'name' => 'id',
                    ];
            }
        }

        if ($show_fields['image']) {
            $input[] = [
                        'col' => 8,
                        'type' => 'tvcmscategory_img',
                        'name' => 'image',
                        'label' => $this->l('Category Image'),
                    ];
        }

        $input[] = [
                        'col' => 8,
                        'type' => 'tvcmscategory_select',
                        'name' => 'id_category',
                        'label' => $this->l('Category'),
                        'lang' => true,
                    ];

        if ($show_fields['title']) {
            $input[] = [
                        'col' => 8,
                        'class' => 'tvcmsvategory-slider-custom-name',
                        'type' => 'text',
                        'name' => 'custom_title',
                        'label' => $this->l('Custom Name'),
                        'lang' => true,
                    ];
        }

        if ($show_fields['short_description']) {
            $input[] = [
                        'col' => 8,
                        'type' => 'text',
                        'name' => 'short_description',
                        'label' => $this->l('Short Description'),
                        'lang' => true,
                    ];
        }

        $input[] = [
                        'col' => 8,
                        'type' => 'switch',
                        'name' => 'status',
                        'label' => $this->l('Status'),
                        'is_bool' => true,
                        'values' => [
                            [
                                'id' => 'active_on',
                                'value' => 1,
                                'label' => $this->l('Show'),
                            ],
                            [
                                'id' => 'active_off',
                                'value' => 0,
                                'label' => $this->l('Hide'),
                            ],
                        ],
                    ];

        return [
            'form' => [
                'legend' => [
                'title' => $this->l('Category Slider'),
                'icon' => 'icon-image',
                ],
                'input' => $input,
                'submit' => [
                    'title' => $this->l('Save'),
                    'name' => 'submitTvcmsCategoryForm',
                ],
            ],
        ];
    }

    protected function tvcmsCategoryTitle()
    {
        $input = [];
        $tvcms_obj = new TvcmsCategorySliderStatus();
        $show_fields = $tvcms_obj->fieldStatusInformation();

        if ($show_fields['main_title']) {
            $input[] = [
                        'col' => 7,
                        'type' => 'text',
                        'name' => 'TVCMSCATEGORY_SLIDER_TITLE',
                        'label' => $this->l('Category Title'),
                        'lang' => true,
                    ];
        }

        if ($show_fields['main_sub_title']) {
            $input[] = [
                    'col' => 7,
                    'type' => 'text',
                    'name' => 'TVCMSCATEGORY_SLIDER_SUB_DESCRIPTION',
                    'label' => $this->l('Short Description'),
                    'lang' => true,
                ];
        }

        if ($show_fields['main_description']) {
            $input[] = [
                    'col' => 7,
                    'type' => 'text',
                    'name' => 'TVCMSCATEGORY_SLIDER_DESCRIPTION',
                    'label' => $this->l('Description'),
                    'lang' => true,
                ];
        }

        if ($show_fields['main_image']) {
            $input[] = [
                        'type' => 'image_file',
                        'name' => 'TVCMSCATEGORY_SLIDER_IMG',
                        'label' => $this->l('Title Image'),
                ];
        }

        return [
            'form' => [
                'legend' => [
                'title' => $this->l('Category Slider Title'),
                'icon' => 'icon-image',
                ],
                'input' => $input,
                'submit' => [
                    'title' => $this->l('Save'),
                    'name' => 'submitTvcmsCategoryTitle',
                ],
            ],
        ];
    }

    public function hookDisplayBackOfficeHeader()
    {
        $this->context->controller->addJqueryUI('ui.sortable');

        if ($this->name == Tools::getValue('configure')) {
            $this->context->controller->addJS($this->_path . 'views/js/back.js');
            $this->context->controller->addCSS($this->_path . 'views/css/back.css');
        }
    }

    public function hookdisplayHeader()
    {
        $this->context->controller->addCSS($this->_path . 'views/css/front.css');
        $this->context->controller->addJS($this->_path . 'views/js/front.js');
    }

    public function hookdisplayLeftColumn()
    {
        return $this->hookDisplayHome();
    }

    public function hookdisplayWrapperTop()
    {
        return $this->hookDisplayHome();
    }

    public function hookDisplayNavFullWidth()
    {
        return $this->hookDisplayHome();
    }

    public function getArrMainTitle($main_heading, $main_heading_data)
    {
        if (!$main_heading['main_title'] || empty($main_heading_data['title'])) {
            $main_heading['main_title'] = false;
        }

        if (!$main_heading['main_sub_title'] || empty($main_heading_data['short_desc'])) {
            $main_heading['main_sub_title'] = false;
        }

        if (!$main_heading['main_description'] || empty($main_heading_data['desc'])) {
            $main_heading['main_description'] = false;
        }

        if (!$main_heading['main_image'] || empty($main_heading_data['image'])) {
            $main_heading['main_image'] = false;
        }

        if (!$main_heading['main_title']
            && !$main_heading['main_sub_title']
            && !$main_heading['main_description']
            && !$main_heading['main_image']) {
            $main_heading['main_status'] = false;
        }

        return $main_heading;
    }

    public function showFrontSideResult()
    {
        $cookie = Context::getContext()->cookie;
        $id_lang = (int) $cookie->id_lang;

        $tvcms_obj = new TvcmsCategorySliderStatus();
        $main_heading = $tvcms_obj->fieldStatusInformation();

        if ($main_heading['main_status']) {
            $main_heading_data = [];
            $main_heading_data['title'] = Configuration::get('TVCMSCATEGORY_SLIDER_TITLE', $id_lang);
            $main_heading_data['short_desc'] = Configuration::get('TVCMSCATEGORY_SLIDER_SUB_DESCRIPTION', $id_lang);
            $main_heading_data['desc'] = Configuration::get('TVCMSCATEGORY_SLIDER_DESCRIPTION', $id_lang);
            $main_heading_data['image'] = Configuration::get('TVCMSCATEGORY_SLIDER_IMG', $id_lang);
            $main_heading = $this->getArrMainTitle($main_heading, $main_heading_data);
            $main_heading['data'] = $main_heading_data;
        }

        $disArrResult = [];
        $disArrResult['data'] = $this->showFrontData();
        $disArrResult['status'] = empty($disArrResult['data']) ? false : true;
        $disArrResult['path'] = _MODULE_DIR_ . $this->name . '/views/img/';
        $disArrResult['id_lang'] = $id_lang;

        $this->context->smarty->assign('main_heading', $main_heading);
        $this->context->smarty->assign('dis_arr_result', $disArrResult);

        return $disArrResult['status'] ? true : false;
    }

    public function hookDisplayHome()
    {
        if (!Cache::isStored('tvcmscategoryslider_display_home.tpl')) {
            $result = $this->showFrontSideResult();

            if ($result) {
                $output = $this->display(__FILE__, 'views/templates/front/display_home.tpl');
            } else {
                $output = '';
            }

            Cache::store('tvcmscategoryslider_display_home.tpl', $output);
        }

        return Cache::retrieve('tvcmscategoryslider_display_home.tpl');
    }

    public function hookdisplayContentWrapperTop()
    {
        return $this->hookDisplayHome();
    }
}