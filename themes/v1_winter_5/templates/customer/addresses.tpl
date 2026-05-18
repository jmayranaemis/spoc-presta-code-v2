{**
 * 2007-2025 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License 3.0 (AFL-3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * https://opensource.org/licenses/AFL-3.0
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
 * @author    PrestaShop SA <contact@prestashop.com>
 * @copyright 2007-2025 PrestaShop SA
 * @license   https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
 * International Registered Trademark & Property of PrestaShop SA
 *}
{strip}
{extends file='customer/page.tpl'}

{block name='page_title'}
  {l s='Your addresses' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  <div class="spoc-account-panel-heading spoc-account-panel-heading-actions">
    <span class="spoc-account-panel-icon">
      <i class="material-icons">&#xE56A;</i>
    </span>
    <div>
      <h2>{l s='Carnet d’adresses' d='Shop.Theme.Customeraccount'}</h2>
      <p>{l s='Gardez vos coordonnées de livraison et de facturation à jour.' d='Shop.Theme.Customeraccount'}</p>
    </div>
    <a href="{$urls.pages.address}" data-link-action="add-address" class="tvall-inner-btn spoc-account-panel-action hidden-sm-down">
      <i class="material-icons">&#xE145;</i>
      <span>{l s='Nouvelle adresse' d='Shop.Theme.Actions'}</span>
    </a>
  </div>

  {if $customer.addresses|count}
    <div class="row tvaddress-save-box spoc-account-address-grid">
      {foreach $customer.addresses as $address}
        <div class="col-lg-6 col-md-6 col-sm-6">
        {block name='customer_address'}
          {include file='customer/_partials/block-address.tpl' address=$address}
        {/block}
        </div>
      {/foreach}
    </div>
  {else}
    <div class="spoc-account-empty-state">
      <i class="material-icons">&#xE567;</i>
      <h3>{l s='Aucune adresse enregistrée' d='Shop.Theme.Customeraccount'}</h3>
      <p>{l s='Ajoutez une adresse pour accélérer vos prochaines commandes.' d='Shop.Theme.Customeraccount'}</p>
    </div>
  {/if}

  <div class="addresses-footer spoc-account-mobile-action">
    <a href="{$urls.pages.address}" data-link-action="add-address" class="tvall-inner-btn">
      <i class="material-icons">&#xE145;</i>
      <span>{l s='Nouvelle adresse' d='Shop.Theme.Actions'}</span>
    </a>
  </div>
{/block}
{/strip}
