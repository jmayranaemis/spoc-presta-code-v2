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
 * obtain a copy immediately, please send an email
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

// use PrestaShop\PrestaShop\Core\Module\WidgetInterface;
use PrestaShop\PrestaShop\Adapter\Category\CategoryProductSearchProvider;
use PrestaShop\PrestaShop\Adapter\Image\ImageRetriever;
use PrestaShop\PrestaShop\Adapter\Product\PriceFormatter;
use PrestaShop\PrestaShop\Adapter\Product\ProductColorsRetriever;
use PrestaShop\PrestaShop\Core\Product\ProductListingPresenter;
use PrestaShop\PrestaShop\Core\Product\Search\ProductSearchContext;
use PrestaShop\PrestaShop\Core\Product\Search\ProductSearchQuery;
use PrestaShop\PrestaShop\Core\Product\Search\SortOrder;

include_once 'classes/tvcmscategoryproduct_image_upload.class.php';
include_once 'classes/tvcmscategoryproduct_status.class.php';

class TvcmsCategoryProduct extends Module
{
    private $html = '';

    private $category_list = [];

    public $id_shop_group = '';

    public $id_shop = '';

    public function __construct()
    {
        $this->name = 'tvcmscategoryproduct';
        $this->tab = 'front_office_features';
        $this->version = '4.0.2';
        $this->author = 'ThemeVolty';
        $this->need_instance = 0;
        $this->secure_key = Tools::encrypt($this->name);
        $this->bootstrap = true;

        parent::__construct();
        $this->displayName = $this->l('ThemeVolty - Tab Categroy Product Slider');
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
            && $this->registerHook('header')
            && $this->registerHook('displayHome');
        // && $this->registerHook('displayNavFullWidth');
    }

    public function installTab()
    {
        $response = true;

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

        $tab = new Tab();
        $tab->active = 1;
        $tab->class_name = 'Admin' . $this->name;
        $tab->name = [];

        foreach (Language::getLanguages() as $lang) {
            $tab->name[(int) $lang['id_lang']] = 'Tab Category Product Slider';
        }

        $tab->id_parent = (int) $parentTab_2->id;
        $tab->module = $this->name;
        $response &= $tab->add();

        return $response;
    }

    public function createDefaultData()
    {
        $this->reset();
        $num_of_data = 7;
        $this->createVariable();
        $this->createTable();
        $this->insertSmapleData($num_of_data);
    }

    public function createVariable()
    {
        $result = [];
        $languages = Language::getLanguages();

        foreach ($languages as $lang) {
            $id_lang = (int) $lang['id_lang'];

            $result['TVCMSCATEGORYPRODUCT_TITLE'][$id_lang] = 'Categories Products';
            $result['TVCMSCATEGORYPRODUCT_PRODUCT_TITLE'][$id_lang] = 'Offer Zone Category';
            $result['TVCMSCATEGORYPRODUCT_SUB_DESCRIPTION'][$id_lang] = 'This is Show Short Description';
            $result['TVCMSCATEGORYPRODUCT_DESCRIPTION'][$id_lang] = 'Description';
            $result['TVCMSCATEGORYPRODUCT_IMG'][$id_lang] = 'demo_title.jpg';
        }

        Configuration::updateValue('TVCMSCATEGORYPRODUCT_TITLE', $result['TVCMSCATEGORYPRODUCT_TITLE']);
        Configuration::updateValue('TVCMSCATEGORYPRODUCT_PRODUCT_TITLE', $result['TVCMSCATEGORYPRODUCT_PRODUCT_TITLE']);
        Configuration::updateValue('TVCMSCATEGORYPRODUCT_SUB_DESCRIPTION', $result['TVCMSCATEGORYPRODUCT_SUB_DESCRIPTION']);
        Configuration::updateValue('TVCMSCATEGORYPRODUCT_DESCRIPTION', $result['TVCMSCATEGORYPRODUCT_DESCRIPTION']);
        Configuration::updateValue('TVCMSCATEGORYPRODUCT_IMG', $result['TVCMSCATEGORYPRODUCT_IMG']);
    }

    public function createTable()
    {
        $create_table = [];

        $create_table[] = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'tvcmscategoryproduct` (
                        `id_tvcmscategoryproduct` int(11) AUTO_INCREMENT PRIMARY KEY,
                        `id_category` int(11),
                        `position` int(11),
                        `id_shop_group` int(11),
                        `id_shop` int(11),
                        `image` VARCHAR(100),
                        `num_of_prod` int(11),
                        `status` varchar(3)
                    ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8;';

        $create_table[] = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'tvcmscategoryproduct_lang` (
                        `id_tvcmscategoryproduct_lang` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                        `id_tvcmscategoryproduct` INT NOT NULL,
                        `id_shop_group` int(11),
                        `id_shop` int(11),
                        `id_category` INT,
                        `id_lang` INT NOT NULL,
                        `title` VARCHAR(255)
                    ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8;';

        foreach ($create_table as $table) {
            Db::getInstance()->execute($table);
        }
    }

    public function insertSmapleData($num_of_data)
    {
        $data = [];
        $category = $this->getAllCategory();

        for ($i = 1; $i <= (int) $num_of_data; ++$i) {
            $category_index = $i - 1;

            if (isset($category[$category_index]['id_category'])) {
                $id_category = (int) $category[$category_index]['id_category'];

                $data[] = 'INSERT INTO `' . _DB_PREFIX_ . 'tvcmscategoryproduct`
                        SET 
                            `id_tvcmscategoryproduct` = ' . (int) $i . ',
                            `position` = ' . (int) $i . ',
                            `id_shop_group` = ' . (int) $this->id_shop_group . ',
                            `id_shop` = ' . (int) $this->id_shop . ',
                            `id_category` = ' . (int) $id_category . ',
                            `image` = \'Category_product_icon_' . (int) $i . '.png\',
                            `num_of_prod` = 8,
                            `status` = \'1\'';

                $languages = Language::getLanguages();

                foreach ($languages as $lang) {
                    $data[] = 'INSERT INTO `' . _DB_PREFIX_ . 'tvcmscategoryproduct_lang`
                        SET 
                            `id_tvcmscategoryproduct_lang` = NULL,
                            `id_tvcmscategoryproduct` = ' . (int) $i . ',
                            `id_shop_group` = ' . (int) $this->id_shop_group . ',
                            `id_shop` = ' . (int) $this->id_shop . ',
                            `id_category` = ' . (int) $id_category . ',
                            `id_lang` = ' . (int) $lang['id_lang'] . ',
                            `title` = \'Title ' . (int) $i . '\'';
                }
            } else {
                $data[] = 'INSERT INTO `' . _DB_PREFIX_ . 'tvcmscategoryproduct`
                        SET 
                            `id_tvcmscategoryproduct` = ' . (int) $i . ',
                            `position` = ' . (int) $i . ',
                            `id_shop_group` = ' . (int) $this->id_shop_group . ',
                            `id_shop` = ' . (int) $this->id_shop . ',
                            `id_category` = 1,
                            `image` = \'Category_product_icon_' . (int) $i . '.png\',
                            `num_of_prod` = 8,
                            `status` = \'0\'';

                $languages = Language::getLanguages();

                foreach ($languages as $lang) {
                    $data[] = 'INSERT INTO `' . _DB_PREFIX_ . 'tvcmscategoryproduct_lang`
                        SET 
                            `id_tvcmscategoryproduct_lang` = NULL,
                            `id_tvcmscategoryproduct` = ' . (int) $i . ',
                            `id_shop_group` = ' . (int) $this->id_shop_group . ',
                            `id_shop` = ' . (int) $this->id_shop . ',
                            `id_category` = 1,
                            `id_lang` = ' . (int) $lang['id_lang'] . ',
                            `title` = \'Title ' . (int) $i . '\'';
                }
            }
        }

        foreach ($data as $query) {
            Db::getInstance()->execute($query);
        }
    }

    public function maxId()
    {
        $select_data = 'SELECT MAX(id_tvcmscategoryproduct) as max_id FROM `' . _DB_PREFIX_ . 'tvcmscategoryproduct`';
        $ans = Db::getInstance()->executeS($select_data);

        return isset($ans[0]['max_id']) ? (int) $ans[0]['max_id'] : 0;
    }

    public function selectAllIdFromTable()
    {
        $select_data = 'SELECT id_tvcmscategoryproduct FROM `' . _DB_PREFIX_ . 'tvcmscategoryproduct`
            WHERE `id_shop_group` = ' . (int) $this->id_shop_group . '
            AND `id_shop` = ' . (int) $this->id_shop . '
            ORDER BY id_tvcmscategoryproduct';

        $ans = Db::getInstance()->executeS($select_data);
        $final_ans = [];

        foreach ($ans as $a) {
            if (isset($a['id_tvcmscategoryproduct'])) {
                $final_ans[] = (int) $a['id_tvcmscategoryproduct'];
            }
        }

        return $final_ans;
    }

    public function selectAllLangIdById($id_tvcmscategoryproduct)
    {
        $select_data = 'SELECT 
                            id_lang 
                        FROM 
                            `' . _DB_PREFIX_ . 'tvcmscategoryproduct_lang` 
                        WHERE 
                            `id_shop_group` = ' . (int) $this->id_shop_group . '
                            AND `id_shop` = ' . (int) $this->id_shop . '
                            AND id_tvcmscategoryproduct = ' . (int) $id_tvcmscategoryproduct;

        $ans = Db::getInstance()->executeS($select_data);
        $return = [];

        foreach ($ans as $a) {
            $return[] = (int) $a['id_lang'];
        }

        return $return;
    }

    public function insertData($data)
    {
        $insert_data = [];

        $id_category = isset($data['id_category']) ? (int) $data['id_category'] : 0;
        $image = isset($data['image']) ? pSQL($data['image']) : '';
        $num_of_prod = isset($data['num_of_prod']) ? (int) $data['num_of_prod'] : 0;
        $status = !empty($data['status']) ? 1 : 0;

        if ($num_of_prod < 1) {
            $num_of_prod = 1;
        }

        if ($num_of_prod > 12) {
            $num_of_prod = 12;
        }

        if (isset($data['id']) && !empty($data['id'])) {
            $id = (int) $data['id'];

            $insert_data[] = 'UPDATE `' . _DB_PREFIX_ . 'tvcmscategoryproduct`
                        SET 
                            `id_category` = ' . (int) $id_category . ',
                            `image` = \'' . $image . '\',
                            `num_of_prod` = ' . (int) $num_of_prod . ',
                            `status` = ' . (int) $status . '
                        WHERE
                            `id_shop_group` = ' . (int) $this->id_shop_group . '
                        AND `id_shop` = ' . (int) $this->id_shop . '
                        AND `id_tvcmscategoryproduct` = ' . (int) $id . ';';

            $result = $this->selectAllLangIdById($id);

            $languages = Language::getLanguages();

            foreach ($languages as $lang) {
                $id_lang = (int) $lang['id_lang'];
                $custom_title = isset($data['lang_info'][$id_lang]['custom_title'])
                    ? pSQL($data['lang_info'][$id_lang]['custom_title'])
                    : '';

                if (in_array($id_lang, $result)) {
                    $insert_data[] = 'UPDATE `' . _DB_PREFIX_ . 'tvcmscategoryproduct_lang`
                            SET 
                                `id_category` = ' . (int) $id_category . ',
                                `id_lang` = ' . (int) $id_lang . ',
                                `title` = \'' . $custom_title . '\'
                            WHERE
                                `id_shop_group` = ' . (int) $this->id_shop_group . '
                            AND 
                                `id_shop` = ' . (int) $this->id_shop . '
                            AND
                                `id_tvcmscategoryproduct` = ' . (int) $id . '
                            AND 
                                `id_lang` = ' . (int) $id_lang . ';';
                } else {
                    $insert_data[] = 'INSERT INTO `' . _DB_PREFIX_ . 'tvcmscategoryproduct_lang`
                        SET 
                            `id_tvcmscategoryproduct_lang` = NULL,
                            `id_tvcmscategoryproduct` = ' . (int) $id . ',
                            `id_shop_group` = ' . (int) $this->id_shop_group . ',
                            `id_shop` = ' . (int) $this->id_shop . ',
                            `id_category` = ' . (int) $id_category . ',
                            `id_lang` = ' . (int) $id_lang . ',
                            `title` = \'' . $custom_title . '\';';
                }
            }
        } else {
            $max_id = $this->maxId();
            $new_id = (int) $max_id + 1;

            $insert_data[] = 'INSERT INTO `' . _DB_PREFIX_ . 'tvcmscategoryproduct`
                        SET 
                            `id_tvcmscategoryproduct` = ' . (int) $new_id . ',
                            `id_category` = ' . (int) $id_category . ',
                            `position` = ' . (int) $new_id . ',
                            `id_shop_group` = ' . (int) $this->id_shop_group . ',
                            `id_shop` = ' . (int) $this->id_shop . ',
                            `image` = \'' . $image . '\',
                            `num_of_prod` = ' . (int) $num_of_prod . ',
                            `status` = ' . (int) $status . ';';

            $languages = Language::getLanguages();

            foreach ($languages as $lang) {
                $id_lang = (int) $lang['id_lang'];
                $custom_title = isset($data['lang_info'][$id_lang]['custom_title'])
                    ? pSQL($data['lang_info'][$id_lang]['custom_title'])
                    : '';

                $insert_data[] = 'INSERT INTO `' . _DB_PREFIX_ . 'tvcmscategoryproduct_lang`
                        SET 
                            `id_tvcmscategoryproduct_lang` = NULL,
                            `id_tvcmscategoryproduct` = ' . (int) $new_id . ',
                            `id_shop_group` = ' . (int) $this->id_shop_group . ',
                            `id_shop` = ' . (int) $this->id_shop . ',
                            `id_category` = ' . (int) $id_category . ',
                            `id_lang` = ' . (int) $id_lang . ',
                            `title` = \'' . $custom_title . '\';';
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

        if (class_exists('Collator') && $collator instanceof Collator) {
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

    public function getAllCategory()
    {
        $category = Category::getAllCategoriesName();
        $all_category_id = [];

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

            $all_category_id[] = [
                'id_category' => $id_category,
                'name' => $name,
            ];
        }

        return $this->sortCategoryRowsByName($all_category_id);
    }

    public function showAdminData()
    {
        $result = [];
        $return_data = [];
        $default_lang_id = (int) $this->context->language->id;

        $select_data = 'SELECT * FROM `' . _DB_PREFIX_ . 'tvcmscategoryproduct`'
             . ' WHERE `id_shop_group` = ' . (int) $this->id_shop_group . ' AND `id_shop` = ' . (int) $this->id_shop
             . ' ORDER BY `position`;';

        $result['tvcmscategoryproduct'] = Db::getInstance()->executeS($select_data);

        $select_data = 'SELECT * FROM `' . _DB_PREFIX_ . 'tvcmscategoryproduct_lang`'
             . ' WHERE `id_shop_group` = ' . (int) $this->id_shop_group . ' AND `id_shop` = ' . (int) $this->id_shop . ';';

        $result['tvcmscategoryproduct_lang'] = Db::getInstance()->executeS($select_data);

        foreach ($result['tvcmscategoryproduct'] as $key => $data) {
            $return_data[$key]['id'] = (int) $data['id_tvcmscategoryproduct'];
            $id = (int) $data['id_tvcmscategoryproduct'];

            foreach ($result['tvcmscategoryproduct_lang'] as $lang) {
                if ($default_lang_id == (int) $lang['id_lang'] && $id == (int) $lang['id_tvcmscategoryproduct']) {
                    $return_data[$key]['id_lang'] = (int) $lang['id_lang'];
                    $return_data[$key]['title'] = $lang['title'];
                }
            }

            $return_data[$key]['id_category'] = (int) $data['id_category'];
            $return_data[$key]['image'] = $data['image'];
            $return_data[$key]['num_of_prod'] = (int) $data['num_of_prod'];
            $return_data[$key]['status'] = (int) $data['status'];
        }

        return $return_data;
    }

    public function showData($id = null)
    {
        $result = [];
        $return_data = [];

        $select_data = '';
        $select_data .= 'SELECT * FROM `' . _DB_PREFIX_ . 'tvcmscategoryproduct` 
                WHERE 
                `id_shop_group` = ' . (int) $this->id_shop_group
                 . ' AND `id_shop` = ' . (int) $this->id_shop;

        if ($id) {
            $select_data .= ' AND `id_tvcmscategoryproduct` = ' . (int) $id;
        } else {
            $select_data .= ' ORDER BY `position`';
        }

        $result['tvcmscategoryproduct'] = Db::getInstance()->executeS($select_data);

        $select_data = '';
        $select_data .= 'SELECT * FROM `' . _DB_PREFIX_ . 'tvcmscategoryproduct_lang`'
             . ' WHERE `id_shop_group` = ' . (int) $this->id_shop_group . ' AND `id_shop` = ' . (int) $this->id_shop;

        if ($id) {
            $select_data .= ' AND id_tvcmscategoryproduct = ' . (int) $id;
        }

        $result['tvcmscategoryproduct_lang'] = Db::getInstance()->executeS($select_data);

        foreach ($result['tvcmscategoryproduct'] as $key => $data) {
            $return_data[$key]['id'] = (int) $data['id_tvcmscategoryproduct'];
            $id = (int) $data['id_tvcmscategoryproduct'];

            foreach ($result['tvcmscategoryproduct_lang'] as $lang) {
                if ($id == (int) $lang['id_tvcmscategoryproduct']) {
                    $id_lang = (int) $lang['id_lang'];
                    $return_data[$key]['lang_info'][$id_lang]['id_lang'] = $id_lang;
                    $return_data[$key]['lang_info'][$id_lang]['title'] = $lang['title'];
                }
            }

            $return_data[$key]['id_category'] = (int) $data['id_category'];
            $return_data[$key]['image'] = $data['image'];
            $return_data[$key]['num_of_prod'] = (int) $data['num_of_prod'];
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
                mainTable.id_tvcmscategoryproduct AS id,
                mainTable.id_category AS id_category,
                mainTable.image,
                mainTable.num_of_prod,
                subTable.title
            FROM 
                `' . _DB_PREFIX_ . 'tvcmscategoryproduct` mainTable
            LEFT JOIN
                `' . _DB_PREFIX_ . 'tvcmscategoryproduct_lang` subTable
            ON
                mainTable.id_tvcmscategoryproduct = subTable.id_tvcmscategoryproduct
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

    public function deleteVariable()
    {
        Configuration::deleteByName('TVCMSCATEGORYPRODUCT_TITLE');
        Configuration::deleteByName('TVCMSCATEGORYPRODUCT_PRODUCT_TITLE');
        Configuration::deleteByName('TVCMSCATEGORYPRODUCT_SUB_DESCRIPTION');
        Configuration::deleteByName('TVCMSCATEGORYPRODUCT_DESCRIPTION');
        Configuration::deleteByName('TVCMSCATEGORYPRODUCT_IMG');
    }

    public function deleteRecord($id)
    {
        $id = (int) $id;

        if ($id <= 0) {
            return;
        }

        $this->removeImage($id);

        $delete_data = [];

        $delete_data[] = 'DELETE FROM `' . _DB_PREFIX_ . 'tvcmscategoryproduct`
            WHERE 
                    `id_shop_group` = ' . (int) $this->id_shop_group . '
                AND 
                    `id_shop` = ' . (int) $this->id_shop . ' 
                AND 
                    `id_tvcmscategoryproduct` = ' . (int) $id;

        $delete_data[] = 'DELETE FROM `' . _DB_PREFIX_ . 'tvcmscategoryproduct_lang` 
            WHERE 
                    `id_shop_group` = ' . (int) $this->id_shop_group . '
                AND 
                    `id_shop` = ' . (int) $this->id_shop . ' 
                AND 
                    id_tvcmscategoryproduct = ' . (int) $id;

        foreach ($delete_data as $query) {
            Db::getInstance()->execute($query);
        }
    }

    public function deleteTable()
    {
        $delete_table = [];

        $delete_table[] = 'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'tvcmscategoryproduct`';
        $delete_table[] = 'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'tvcmscategoryproduct_lang`';

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

        $trn_tbl[] = 'TRUNCATE `' . _DB_PREFIX_ . 'tvcmscategoryproduct`';
        $trn_tbl[] = 'TRUNCATE `' . _DB_PREFIX_ . 'tvcmscategoryproduct_lang`';

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
        $url_slidersampleupgrade = $baseDir . $admin_folder . '/index.php?controller=AdminModules&configure=' . $this->name . '&tab_module=front_office_features&module_name=' . $this->name . '&token=' . $static_token;
        $this->context->smarty->assign('tvurlupgrade', $url_slidersampleupgrade);

        if (Tools::isSubmit('submitTvcmsSampleinstall')) {
            $this->createDefaultData();
        }

        $message = $this->postProcess();

        $this->html .= $message;
        $this->html .= $this->renderForm();
        $this->html .= $this->showRecord();

        return $this->html;
    }

    public function postProcess()
    {
        $languages = Language::getLanguages();
        $message = '';
        $result = [];

        if (Tools::getValue('action')) {
            $action = Tools::getValue('action');
            $id = (int) Tools::getValue('id');

            if ('remove' == $action && $id > 0) {
                $this->deleteRecord($id);

                return $message .= $this->displayConfirmation($this->l('Record is Deleted . '));
            }
        }

        if (Tools::isSubmit('submitTvcmsCategoryForm')) {
            $old_file = 'demo_img_1.jpg';
            $no_image_selected = false;

            if (Tools::getValue('id')) {
                $id = (int) Tools::getValue('id');
                $result['id'] = $id;
                $data = $this->showData($id);

                if (!empty($data[0]['image'])) {
                    $old_file = $data[0]['image'];
                }
            }

            $tvcms_obj = new TvcmsCategoryProductStatus();
            $show_fields = $tvcms_obj->fieldStatusInformation();

            if ($show_fields['image']) {
                $this->obj_image = new TvcmsCategoryProductImageUpload();

                if (!empty($_FILES['image']['name'])) {
                    $new_file = $_FILES['image'];
                    $ans = $this->obj_image->imageUploading($new_file, $old_file);

                    if (!empty($ans['success'])) {
                        $result['image'] = isset($ans['name']) ? $ans['name'] : '';
                    } else {
                        $message .= isset($ans['error']) ? $ans['error'] : $this->displayError($this->l('Image upload error.'));
                        $result['image'] = $old_file;

                        if (!Tools::getValue('id')) {
                            $no_image_selected = true;
                        }
                    }
                } else {
                    $result['image'] = $old_file;

                    if (!Tools::getValue('id')) {
                        $message .= $this->displayError($this->l('Please Select Image . '));
                        $no_image_selected = true;
                    }
                }
            } else {
                $result['image'] = $old_file;
            }

            if (!$no_image_selected) {
                foreach ($languages as $lang) {
                    $id_lang = (int) $lang['id_lang'];
                    $tmp = Tools::getValue('custom_title_' . $id_lang);
                    $result['lang_info'][$id_lang]['custom_title'] = $tmp;
                }

                $result['id_category'] = (int) Tools::getValue('id_category');
                $result['num_of_prod'] = (int) Tools::getValue('num_of_prod');
                $result['status'] = !empty(Tools::getValue('status')) ? 1 : 0;

                if ($result['id_category'] <= 0 || !$this->isSelectableCategory($result['id_category'])) {
                    $message .= $this->displayError($this->l('Please select valid category.'));
                } else {
                    $this->insertData($result);
                    $message .= $this->displayConfirmation($this->l('Record is save successfully.'));
                }

                $this->clearCustomSmartyCache('tvcmscategoryproduct_display_home.tpl');
            }

            return $message;
        }

        if (Tools::isSubmit('submitTvcmsCategoryTitle')) {
            foreach ($languages as $lang) {
                $id_lang = (int) $lang['id_lang'];

                $this->obj_image = new TvcmsCategoryProductImageUpload();

                if (!empty($_FILES['TVCMSCATEGORYPRODUCT_IMG_' . $id_lang]['name'])) {
                    $old_file = Configuration::get('TVCMSCATEGORYPRODUCT_IMG', $id_lang);
                    $new_file = $_FILES['TVCMSCATEGORYPRODUCT_IMG_' . $id_lang];
                    $ans = $this->obj_image->imageUploading($new_file, $old_file);

                    if (!empty($ans['success'])) {
                        $result['TVCMSCATEGORYPRODUCT_IMG'][$id_lang] = isset($ans['name']) ? $ans['name'] : '';
                    } else {
                        $message .= isset($ans['error']) ? $ans['error'] : $this->displayError($this->l('Image upload error.'));
                        $result['TVCMSCATEGORYPRODUCT_IMG'][$id_lang] = $old_file;
                    }
                } else {
                    $old_file = Configuration::get('TVCMSCATEGORYPRODUCT_IMG', $id_lang);
                    $result['TVCMSCATEGORYPRODUCT_IMG'][$id_lang] = $old_file;
                }

                $tmp = Tools::getValue('TVCMSCATEGORYPRODUCT_TITLE_' . $id_lang);
                $result['TVCMSCATEGORYPRODUCT_TITLE'][$id_lang] = $tmp;

                $tmp = Tools::getValue('TVCMSCATEGORYPRODUCT_PRODUCT_TITLE_' . $id_lang);
                $result['TVCMSCATEGORYPRODUCT_PRODUCT_TITLE'][$id_lang] = $tmp;

                $tmp = Tools::getValue('TVCMSCATEGORYPRODUCT_SUB_DESCRIPTION_' . $id_lang);
                $result['TVCMSCATEGORYPRODUCT_SUB_DESCRIPTION'][$id_lang] = $tmp;

                $tmp = Tools::getValue('TVCMSCATEGORYPRODUCT_DESCRIPTION_' . $id_lang);
                $result['TVCMSCATEGORYPRODUCT_DESCRIPTION'][$id_lang] = $tmp;
            }

            Configuration::updateValue('TVCMSCATEGORYPRODUCT_TITLE', $result['TVCMSCATEGORYPRODUCT_TITLE']);
            Configuration::updateValue('TVCMSCATEGORYPRODUCT_PRODUCT_TITLE', $result['TVCMSCATEGORYPRODUCT_PRODUCT_TITLE']);
            Configuration::updateValue('TVCMSCATEGORYPRODUCT_SUB_DESCRIPTION', $result['TVCMSCATEGORYPRODUCT_SUB_DESCRIPTION']);
            Configuration::updateValue('TVCMSCATEGORYPRODUCT_DESCRIPTION', $result['TVCMSCATEGORYPRODUCT_DESCRIPTION']);
            Configuration::updateValue('TVCMSCATEGORYPRODUCT_IMG', $result['TVCMSCATEGORYPRODUCT_IMG']);

            return $message .= $this->displayConfirmation($this->l('Category Slider Title Updated.'));
        }

        return $message;
    }

    public function clearCustomSmartyCache($cache_id)
    {
        if (Cache::isStored($cache_id)) {
            Cache::clean($cache_id);
        }
    }

    public function showRecord()
    {
        $array_list = $this->showAdminData();
        $category_list = $this->getAllCategoryByIdsKey();

        $tvcms_obj = new TvcmsCategoryProductStatus();
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

        foreach ($languages as $lang) {
            $id_lang_item = (int) $lang['id_lang'];

            $fields['TVCMSCATEGORYPRODUCT_TITLE'][$id_lang_item] = Configuration::get('TVCMSCATEGORYPRODUCT_TITLE', $id_lang_item);
            $fields['TVCMSCATEGORYPRODUCT_PRODUCT_TITLE'][$id_lang_item] = Configuration::get('TVCMSCATEGORYPRODUCT_PRODUCT_TITLE', $id_lang_item);
            $fields['TVCMSCATEGORYPRODUCT_SUB_DESCRIPTION'][$id_lang_item] = Configuration::get('TVCMSCATEGORYPRODUCT_SUB_DESCRIPTION', $id_lang_item);
            $fields['TVCMSCATEGORYPRODUCT_DESCRIPTION'][$id_lang_item] = Configuration::get('TVCMSCATEGORYPRODUCT_DESCRIPTION', $id_lang_item);
            $fields['TVCMSCATEGORYPRODUCT_IMG'][$id_lang_item] = Configuration::get('TVCMSCATEGORYPRODUCT_IMG', $id_lang_item);
        }

        $path = _MODULE_DIR_ . $this->name . '/views/img/';
        $this->context->smarty->assign('path', $path);

        $all_category = $this->getAllCategory();
        $this->context->smarty->assign('all_category', $all_category);

        $fields['id'] = '';

        foreach ($languages as $lang) {
            $fields['custom_title'][(int) $lang['id_lang']] = '';
        }

        $fields['image'] = '';
        $fields['num_of_prod'] = '';
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
                }

                $fields['image'] = isset($data['image']) ? $data['image'] : '';
                $fields['num_of_prod'] = isset($data['num_of_prod']) ? (int) $data['num_of_prod'] : '';
                $fields['status'] = isset($data['status']) ? (int) $data['status'] : 1;

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

        $module = 'tvcmscategoryproduct';
        $url = 'index.php?controller=AdminModules&configure=' . $module . '&token=' . Tools::getAdminTokenLite('AdminModules');

        $helper->back_url = $url;
        $helper->tpl_vars = [
            'fields_value' => $this->getConfigFormValues(),
            'languages' => $this->context->controller->getLanguages(),
            'id_language' => (int) $this->context->language->id,
        ];

        $form = [];
        $tvcms_obj = new TvcmsCategoryProductStatus();
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
        $tvcms_obj = new TvcmsCategoryProductStatus();
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
                'label' => $this->l('Category image'),
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

        if ($show_fields['num_of_prod']) {
            $min = 1;
            $max = 12;
            $range = [];

            for ($i = $min; $i <= $max; ++$i) {
                $range[] = [
                    'id_option' => $i,
                    'name' => $i,
                ];
            }

            $input[] = [
                'col' => 8,
                'type' => 'select',
                'label' => $this->l('Number Of Product'),
                'desc' => $this->l('Number of product which show in tab category products'),
                'name' => 'num_of_prod',
                'options' => [
                    'query' => $range,
                    'id' => 'id_option',
                    'name' => 'name',
                ],
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
        $tvcms_obj = new TvcmsCategoryProductStatus();
        $show_fields = $tvcms_obj->fieldStatusInformation();

        if ($show_fields['main_title']) {
            $input[] = [
                'col' => 7,
                'type' => 'text',
                'name' => 'TVCMSCATEGORYPRODUCT_TITLE',
                'label' => $this->l('Category Title'),
                'lang' => true,
            ];
        }

        if ($show_fields['main_product_title']) {
            $input[] = [
                'col' => 7,
                'type' => 'text',
                'name' => 'TVCMSCATEGORYPRODUCT_PRODUCT_TITLE',
                'label' => $this->l('Category Product Title'),
                'lang' => true,
            ];
        }

        if ($show_fields['main_sub_title']) {
            $input[] = [
                'col' => 7,
                'type' => 'text',
                'name' => 'TVCMSCATEGORYPRODUCT_SUB_DESCRIPTION',
                'label' => $this->l('Short Description'),
                'lang' => true,
            ];
        }

        if ($show_fields['main_description']) {
            $input[] = [
                'col' => 7,
                'type' => 'text',
                'name' => 'TVCMSCATEGORYPRODUCT_DESCRIPTION',
                'label' => $this->l('Description'),
                'lang' => true,
            ];
        }

        if ($show_fields['main_image']) {
            $input[] = [
                'type' => 'image_file',
                'name' => 'TVCMSCATEGORYPRODUCT_IMG',
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

    public function hookHeader()
    {
        $tmp = $this->context->link->getModuleLink('tvcmscategoryproduct', 'default');
        Media::addJsDef(['gettvcmscategoryproductlink' => $tmp]);

        $useSSL = ((isset($this->ssl) && $this->ssl && Configuration::get('PS_SSL_ENABLED'))
            || Tools::usingSecureMode()) ? true : false;

        $protocol_content = ($useSSL) ? 'https://' : 'http://';

        $tmp = $protocol_content . Tools::getHttpHost() . __PS_BASE_URI__;

        Media::addJsDef(['baseDir' => $tmp]);

        $this->context->controller->addCSS($this->_path . 'views/css/front.css');
        $this->context->controller->addJS($this->_path . 'views/js/front.js');
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

        $tvcms_obj = new TvcmsCategoryProductStatus();
        $main_heading = $tvcms_obj->fieldStatusInformation();

        if ($main_heading['main_status']) {
            $main_heading_data = [];
            $main_heading_data['title'] = Configuration::get('TVCMSCATEGORYPRODUCT_TITLE', $id_lang);
            $main_heading_data['product_title'] = Configuration::get('TVCMSCATEGORYPRODUCT_PRODUCT_TITLE', $id_lang);
            $main_heading_data['short_desc'] = Configuration::get('TVCMSCATEGORYPRODUCT_SUB_DESCRIPTION', $id_lang);
            $main_heading_data['desc'] = Configuration::get('TVCMSCATEGORYPRODUCT_DESCRIPTION', $id_lang);
            $main_heading_data['image'] = Configuration::get('TVCMSCATEGORYPRODUCT_IMG', $id_lang);
            $main_heading = $this->getArrMainTitle($main_heading, $main_heading_data);
            $main_heading['data'] = $main_heading_data;
        }

        $disArrResult = [];
        $disArrResult['data'] = $this->showFrontData();
        $disArrResult['status'] = empty($disArrResult['data']) ? false : true;
        $disArrResult['path'] = _MODULE_DIR_ . $this->name . '/views/img/';
        $disArrResult['id_lang'] = $id_lang;

        $useSSL = ((isset($this->ssl) && $this->ssl && Configuration::get('PS_SSL_ENABLED'))
            || Tools::usingSecureMode()) ? true : false;

        $protocol_content = ($useSSL) ? 'https://' : 'http://';
        $baseurl = $protocol_content . Tools::getHttpHost() . __PS_BASE_URI__;

        $disArrResult['baseUrl'] = $baseurl;

        $this->context->smarty->assign('main_heading', $main_heading);
        $this->context->smarty->assign('dis_arr_result', $disArrResult);

        return $disArrResult['status'] ? true : false;
    }

    public function hookdisplayHome()
    {
        if (!Cache::isStored('tvcmscategoryproduct_display_home.tpl')) {
            $result = $this->showFrontSideResult();

            if ($result) {
                $output = $this->display(__FILE__, 'views/templates/front/display_home.tpl');
            } else {
                $output = '';
            }

            Cache::store('tvcmscategoryproduct_display_home.tpl', $output);
        }

        return Cache::retrieve('tvcmscategoryproduct_display_home.tpl');
    }

    public function getProductsUsingCategory($category_id, $num_of_prod)
    {
        $category = new Category((int) $category_id);

        $searchProvider = new CategoryProductSearchProvider(
            $this->context->getTranslator(),
            $category
        );

        $context = new ProductSearchContext($this->context);

        $query = new ProductSearchQuery();

        $nProducts = (int) $num_of_prod;

        if ($nProducts < 1) {
            $nProducts = 1;
        }

        if ($nProducts > 12) {
            $nProducts = 12;
        }

        $query
            ->setResultsPerPage($nProducts)
            ->setPage(1);

        $query->setSortOrder(new SortOrder('product', 'position', 'asc'));

        $result = $searchProvider->runQuery(
            $context,
            $query
        );

        $assembler = new ProductAssembler($this->context);

        $presenterFactory = new ProductPresenterFactory($this->context);
        $presentationSettings = $presenterFactory->getPresentationSettings();

        $presenter = new ProductListingPresenter(
            new ImageRetriever(
                $this->context->link
            ),
            $this->context->link,
            new PriceFormatter(),
            new ProductColorsRetriever(),
            $this->context->getTranslator()
        );

        $product_list = [];

        foreach ($result->getProducts() as $rawProduct) {
            $product_list[] = $presenter->present(
                $presentationSettings,
                $assembler->assembleProduct($rawProduct),
                $this->context->language
            );
        }

        $stockInfoModule = Module::getInstanceByName('tvcmsstockinfo');
        if ($stockInfoModule && method_exists($stockInfoModule, 'getProductGridStockSizes')) {
            foreach ($product_list as $key => $product) {
                if (!empty($product['id_product'])) {
                    $product_list[$key]['spoc_stock_sizes'] = $stockInfoModule->getProductGridStockSizes(
                        (int) $product['id_product']
                    );
                }
            }
        }

        $cart_page_url = $this->context->link->getPageLink(
            'cart',
            null,
            (int) $this->context->language->id,
            null,
            false,
            null,
            true
        );

        $imageRetriever = new ImageRetriever($this->context->link);
        $no_picture_image = $imageRetriever->getNoPictureImage($this->context->language);

        $img = $no_picture_image['bySize'][ImageType::getFormattedName('home')]['url'];

        $this->context->smarty->assign('no_picture_image', $img);

        $static_token = Tools::getToken(false);
        $img_url = _THEME_IMG_DIR_;

        $this->context->smarty->assign('img_url', $img_url);
        $this->context->smarty->assign('cart_page_url', $cart_page_url);
        $this->context->smarty->assign('static_token', $static_token);
        $this->context->smarty->assign('product_list', $product_list);
        $this->context->smarty->assign('num_of_prod', $nProducts);

        return $this->display(__FILE__, './views/templates/front/show_product.tpl');
    }
}
