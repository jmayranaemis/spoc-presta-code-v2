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
 *  @author PrestaShop SA <contact@prestashop.com>
 *  @copyright 2007-2025 PrestaShop SA
 *  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 *  International Registered Trademark & Property of PrestaShop SA
 */
class AdmintvcmsimagetypeController extends ModuleAdminController
{
    public function __construct()
    {
        $this->table = 'tvcms_image_type';
        $this->className = 'tvcmsimagetypeclass';
        $this->deleted = false;
        $this->module = 'tvcmsblog';
        $this->allow_export = false;
        $this->_defaultOrderWay = 'DESC';
        $this->bootstrap = true;
        parent::__construct();
        $this->fields_list = [
            'id_tvcms_image_type' => [
                'title' => $this->l('ID'),
                'width' => 100,
                'type' => 'text',
            ],
            'name' => [
                'title' => $this->l('Name'),
                'width' => 60,
                'type' => 'text',
            ],
            'width' => [
                'title' => $this->l('Width'),
                'width' => 220,
                'type' => 'text',
            ],
            'height' => [
                'title' => $this->l('Height'),
                'width' => 100,
                'type' => 'text',
            ],
            'active' => [
                'title' => $this->l('Status'),
                'active' => 'status',
                'type' => 'bool',
                'orderby' => false,
            ],
        ];
        $this->bulk_actions = [
            'delete' => [
                'text' => $this->l('Delete selected'),
                'icon' => 'icon-trash',
                'confirm' => $this->l('Delete selected items?'),
            ],
        ];
        parent::__construct();
    }

    public function init()
    {
        parent::init();
        $id_shop = (int) Context::getContext()->shop->id;
        $this->_select = ' a.id_shop = ' . $id_shop;
    }

    public function renderForm()
    {
        $this->fields_form = [
            'legend' => [
                'title' => $this->l('JHPTemplate Blog Image Type'),
            ],
            'input' => [
                [
                    'type' => 'text',
                    'label' => $this->l('Name'),
                    'name' => 'name',
                    'desc' => $this->l('Enter Your Image Type Name'),
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Width'),
                    'name' => 'width',
                    'desc' => $this->l('Enter Your Width'),
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Height'),
                    'name' => 'height',
                    'desc' => $this->l('Enter Your Height'),
                ],
                [
                    'type' => 'switch',
                    'label' => $this->l('Status'),
                    'name' => 'active',
                    'required' => false,
                    'class' => 't',
                    'is_bool' => true,
                    'values' => [
                        [
                            'id' => 'active',
                            'value' => 1,
                            'label' => $this->l('Enabled'),
                        ],
                        [
                            'id' => 'active',
                            'value' => 0,
                            'label' => $this->l('Disabled'),
                        ],
                    ],
                ],
            ],
            'submit' => [
                'title' => $this->l('Save'),
                'class' => 'btn btn-default pull-right',
            ],
        ];
        if (!($tvcmsimagetypeclass = $this->loadObject(true))) {
            return;
        }

        return parent::renderForm();
    }

    public function renderList()
    {
        $this->addRowAction('edit');
        $this->addRowAction('delete');

        return parent::renderList();
    }
}
