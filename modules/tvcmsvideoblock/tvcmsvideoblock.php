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

include_once 'classes/tvcmsvideoblock_image_upload.class.php';

class TvcmsVideoBlock extends Module
{
    public function __construct()
    {
        $this->name = 'tvcmsvideoblock';
        $this->tab = 'front_office_features';
        $this->version = '2.1.8';
        $this->author = 'ThemeVolty';
        $this->need_instance = 0;

        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('ThemeVolty - Video Block');
        $this->description = $this->l('Adds an Video Block to your homepage.');

        $this->ps_versions_compliancy = ['min' => '1.7', 'max' => _PS_VERSION_];
        $this->module_key = '';

        $this->confirmUninstall = $this->l('Warning: all the data saved in your database will be deleted.' .
            ' Are you sure you want uninstall this module?');
    }// __construct()

    public function install()
    {
        $this->installTab();
        // $this->createDefaultData();

        return parent::install()
            && $this->registerHook('displayHome')
            && $this->registerHook('displayHeader')
            && $this->registerHook('displayBackOfficeHeader');
    }// install()

    public function createDefaultData()
    {
        $result = [];
        $languages = Language::getLanguages();

        foreach ($languages as $lang) {
            $result['TVCMSVIDEOBLOCK_VIDEO_TITLE'][$lang['id_lang']] = 'Comfor & Visison';
            $result['TVCMSVIDEOBLOCK_VIDEO_DESC'][$lang['id_lang']] = 'New collection';
            $result['TVCMSVIDEOBLOCK_VIDEO_BTN_CAPTION'][$lang['id_lang']] = 'Watch Trailer';
        }

        Configuration::updateValue('TVCMSVIDEOBLOCK_VIDEO_IMG', 'demo_img_1.jpg');
        Configuration::updateValue('TVCMSVIDEOBLOCK_VIDEO_LINK', 'https://www.youtube.com/embed/odCBKHYVsEw');
        Configuration::updateValue('TVCMSVIDEOBLOCK_VIDEO_TITLE', $result['TVCMSVIDEOBLOCK_VIDEO_TITLE']);
        Configuration::updateValue('TVCMSVIDEOBLOCK_VIDEO_DESC', $result['TVCMSVIDEOBLOCK_VIDEO_DESC']);
        // For This Theme btn is use for Bottom Title
        Configuration::updateValue('TVCMSVIDEOBLOCK_VIDEO_BTN_CAPTION', $result['TVCMSVIDEOBLOCK_VIDEO_BTN_CAPTION']);
        Configuration::updateValue('TVCMSVIDEOBLOCK_VIDEO_STATUS', '1');
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
                $parentTab->name[$lang['id_lang']] = 'ThemeVolty Extension';
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
                $parentTab_2->name[$lang['id_lang']] = 'ThemeVolty Configure';
            }
            $parentTab_2->id_parent = $parentTab->id;
            $parentTab_2->module = $this->name;
            $response &= $parentTab_2->add();
        }
        // Created tab
        $tab = new Tab();
        $tab->active = 1;
        $tab->class_name = 'Admin' . $this->name;
        $tab->name = [];
        foreach (Language::getLanguages() as $lang) {
            $tab->name[$lang['id_lang']] = 'Video Block';
        }
        $tab->id_parent = $parentTab_2->id;
        $tab->module = $this->name;
        $response &= $tab->add();

        return $response;
    }

    public function uninstall()
    {
        $this->uninstallTab();

        return parent::uninstall();
    }// uninstall()

    public function uninstallTab()
    {
        $id_tab = Tab::getIdFromClassName('Admin' . $this->name);
        $tab = new Tab($id_tab);
        $tab->delete();

        return true;
    }

    /**
     * Load the configuration form.
     */
    public function getContent()
    {
        if (Tools::isSubmit('submitTvcmsSampleinstall') && '1' == Tools::getValue('tvinstalldata')) {
            $this->createDefaultData();
        }
        $messages = '';
        if (Tools::getValue('submitTvcmsVideoForm')) {
            $messages .= $this->postProcess();
        }

        $output = $messages . $this->renderForm();

        return $output;
    }

    public function postProcess()
    {
        $messages = '';
        $languages = Language::getLanguages();
        if (!empty($_FILES['TVCMSVIDEOBLOCK_VIDEO_IMG']['name'])) {
            $tvcms_obj = new TvcmsVideoBlockImageUpload();
            $old_image_name = Configuration::get('TVCMSVIDEOBLOCK_VIDEO_IMG');
            $result = $tvcms_obj->imageUploading($_FILES['TVCMSVIDEOBLOCK_VIDEO_IMG'], $old_image_name);
            if ($result['success']) {
                Configuration::updateValue('TVCMSVIDEOBLOCK_VIDEO_IMG', $result['name']);
                $messages .= $this->displayConfirmation($this->l('Background Image is Uploaded'));
            } else {
                $messages = $result['error'];
            }
        }

        foreach ($languages as $lang) {
            $tmp = Tools::getValue('TVCMSVIDEOBLOCK_VIDEO_TITLE_' . $lang['id_lang']);
            $result['TVCMSVIDEOBLOCK_VIDEO_TITLE'][$lang['id_lang']] = $tmp;
            $tmp = Tools::getValue('TVCMSVIDEOBLOCK_VIDEO_DESC_' . $lang['id_lang']);
            $result['TVCMSVIDEOBLOCK_VIDEO_DESC'][$lang['id_lang']] = $tmp;
            $tmp = Tools::getValue('TVCMSVIDEOBLOCK_VIDEO_BTN_CAPTION_' . $lang['id_lang']);
            $result['TVCMSVIDEOBLOCK_VIDEO_BTN_CAPTION'][$lang['id_lang']] = $tmp;
        }

        Configuration::updateValue('TVCMSVIDEOBLOCK_VIDEO_LINK', Tools::getValue('TVCMSVIDEOBLOCK_VIDEO_LINK'));
        Configuration::updateValue('TVCMSVIDEOBLOCK_VIDEO_TITLE', $result['TVCMSVIDEOBLOCK_VIDEO_TITLE']);
        Configuration::updateValue('TVCMSVIDEOBLOCK_VIDEO_DESC', $result['TVCMSVIDEOBLOCK_VIDEO_DESC']);
        $tmp = $result['TVCMSVIDEOBLOCK_VIDEO_BTN_CAPTION'];
        Configuration::updateValue('TVCMSVIDEOBLOCK_VIDEO_BTN_CAPTION', $tmp);
        $tmp = Tools::getValue('TVCMSVIDEOBLOCK_VIDEO_STATUS');
        Configuration::updateValue('TVCMSVIDEOBLOCK_VIDEO_STATUS', $tmp);

        $messages .= $this->displayConfirmation($this->l('Video Information is Updated'));
    }

    protected function renderForm()
    {
        $helper = new HelperForm();

        $helper->show_toolbar = false;
        $helper->table = $this->table;
        $helper->module = $this;
        $helper->default_form_language = $this->context->language->id;
        $helper->allow_employee_form_lang = Configuration::get('PS_BO_ALLOW_EMPLOYEE_FORM_LANG', 0);

        $helper->identifier = $this->identifier;
        $helper->currentIndex = $this->context->link->getAdminLink('AdminModules', false)
            . '&configure=' . $this->name . '&tab_module=' . $this->tab . '&module_name=' . $this->name;
        $helper->token = Tools::getAdminTokenLite('AdminModules');
        $helper->tpl_vars = [
            'fields_value' => $this->getConfigFormValues(), // Add values for your inputs
            'languages' => $this->context->controller->getLanguages(),
            'id_language' => $this->context->language->id,
        ];

        return $helper->generateForm([
            $this->tvcmsVideoForm(),
        ]);
    }

    protected function tvcmsVideoForm()
    {
        return [
            'form' => [
                'legend' => [
                'title' => $this->l('Video Link'),
                'icon' => 'icon-facetime-video',
                ],
                'input' => [
                    [
                        'col' => 12,
                        'type' => 'BtnInstallData',
                        'name' => 'BtnInstallData',
                        'label' => '',
                    ],
                    [
                        'col' => 8,
                        'type' => 'file_upload',
                        'name' => 'TVCMSVIDEOBLOCK_VIDEO_IMG',
                        'label' => $this->l('Backgorund Image'),
                    ],
                    [
                        'col' => 8,
                        'type' => 'text',
                        'name' => 'TVCMSVIDEOBLOCK_VIDEO_LINK',
                        'label' => $this->l('Video Link'),
                        'desc' => $this->l('Enter Youtube Embeded Video Link. '
                            . 'Ex:-https://www.youtube.com/embed/jlJVEAzRdrE'),
                    ],
                    [
                        'col' => 8,
                        'type' => 'text',
                        'name' => 'TVCMSVIDEOBLOCK_VIDEO_TITLE',
                        'label' => $this->l('Title'),
                        'lang' => true,
                        'desc' => $this->l('Display Video Title in Front Side'),
                    ],
                    [
                        'col' => 8,
                        'type' => 'text',
                        'name' => 'TVCMSVIDEOBLOCK_VIDEO_DESC',
                        'label' => $this->l('Short Description'),
                        'lang' => true,
                        'desc' => $this->l('Display Video Description in Front Side'),
                    ],
                    [
                        'col' => 8,
                        'type' => 'text',
                        'name' => 'TVCMSVIDEOBLOCK_VIDEO_BTN_CAPTION',
                        'label' => $this->l('Bottom Title'),
                        'lang' => true,
                        'desc' => $this->l('Display Video Button Caption in Front Side'),
                    ],
                    [
                        'type' => 'switch',
                        'label' => $this->l('Status'),
                        'name' => 'TVCMSVIDEOBLOCK_VIDEO_STATUS',
                        'desc' => $this->l('Status of Youtube in Front Side'),
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
                    ],
                ],
                'submit' => [
                    'title' => $this->l('Save'),
                    'name' => 'submitTvcmsVideoForm',
                ],
            ],
        ];
    }

    public function getConfigFormValues()
    {
        $result = [];
        $languages = Language::getLanguages();

        foreach ($languages as $lang) {
            $tmp = Configuration::get('TVCMSVIDEOBLOCK_VIDEO_TITLE', $lang['id_lang']);
            $result['TVCMSVIDEOBLOCK_VIDEO_TITLE'][$lang['id_lang']] = $tmp;
            $tmp = Configuration::get('TVCMSVIDEOBLOCK_VIDEO_DESC', $lang['id_lang']);
            $result['TVCMSVIDEOBLOCK_VIDEO_DESC'][$lang['id_lang']] = $tmp;
            $tmp = Configuration::get('TVCMSVIDEOBLOCK_VIDEO_BTN_CAPTION', $lang['id_lang']);
            $result['TVCMSVIDEOBLOCK_VIDEO_BTN_CAPTION'][$lang['id_lang']] = $tmp;
        }
        $path = _PS_BASE_URL_ . _MODULE_DIR_ . $this->name . '/views/img/';
        $this->context->smarty->assign('path', $path);

        return [
            'TVCMSVIDEOBLOCK_VIDEO_IMG' => Configuration::get('TVCMSVIDEOBLOCK_VIDEO_IMG'),
            'TVCMSVIDEOBLOCK_VIDEO_LINK' => Configuration::get('TVCMSVIDEOBLOCK_VIDEO_LINK'),
            'TVCMSVIDEOBLOCK_VIDEO_TITLE' => $result['TVCMSVIDEOBLOCK_VIDEO_TITLE'],
            'TVCMSVIDEOBLOCK_VIDEO_DESC' => $result['TVCMSVIDEOBLOCK_VIDEO_DESC'],
            'TVCMSVIDEOBLOCK_VIDEO_BTN_CAPTION' => $result['TVCMSVIDEOBLOCK_VIDEO_BTN_CAPTION'],
            'TVCMSVIDEOBLOCK_VIDEO_STATUS' => Configuration::get('TVCMSVIDEOBLOCK_VIDEO_STATUS'),
        ];
    }

    public function hookDisplayBackOfficeHeader()
    {
        if ($this->name == Tools::getValue('configure')) {
            $this->context->controller->addJS($this->_path . 'views/js/back.js');
            $this->context->controller->addCSS($this->_path . 'views/css/back.css');
        }
    }// hookDisplayBackOfficeHeader()

    public function hookDisplayHeader()
    {
        $this->context->controller->addCSS($this->_path . 'views/css/front.css');
    }

    public function hookDisplayHome()
    {
        $cookie = Context::getContext()->cookie;
        $id_lang = $cookie->id_lang;
        $html = '';

        $video_img = Configuration::get('TVCMSVIDEOBLOCK_VIDEO_IMG');
        $this->context->smarty->assign('video_img', $video_img);
        $video_link = Configuration::get('TVCMSVIDEOBLOCK_VIDEO_LINK');
        $this->context->smarty->assign('video_link', $video_link);
        $video_title = Configuration::get('TVCMSVIDEOBLOCK_VIDEO_TITLE', $id_lang);
        $this->context->smarty->assign('video_title', $video_title);
        $video_desc = Configuration::get('TVCMSVIDEOBLOCK_VIDEO_DESC', $id_lang);
        $this->context->smarty->assign('video_desc', $video_desc);
        $video_btn_caption = Configuration::get('TVCMSVIDEOBLOCK_VIDEO_BTN_CAPTION', $id_lang);
        $this->context->smarty->assign('video_btn_caption', $video_btn_caption);
        $Videopath = _PS_BASE_URL_ . _MODULE_DIR_ . $this->name . '/views/img/';
        $this->context->smarty->assign('Videopath', $Videopath);

        if (empty($video_btn_caption)) {
            $video_btn_caption = 'PLAY NOW';
            $this->context->smarty->assign('video_btn_caption', $video_btn_caption);
        }
        $video_status = Configuration::get('TVCMSVIDEOBLOCK_VIDEO_STATUS');
        $this->context->smarty->assign('video_status', $video_status);

        return $this->display(__FILE__, 'views/templates/front/display_home.tpl');
    }
}
