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
{if !isset($spoc_account_active)}
  {assign var='spoc_account_active' value=$page.page_name}
{/if}

<aside class="spoc-account-sidebar">
  <div class="spoc-account-sidebar-title">{l s='Mon compte' d='Shop.Theme.Customeraccount'}</div>
  <nav class="spoc-account-nav" aria-label="{l s='Navigation du compte' d='Shop.Theme.Customeraccount'}">
    <a class="spoc-account-nav-link{if $spoc_account_active == 'my-account'} active{/if}" href="{$urls.pages.my_account}">
      <i class="material-icons">&#xE871;</i>
      <span>{l s='Mon compte' d='Shop.Theme.Customeraccount'}</span>
    </a>
    {if !$configuration.is_catalog}
      <a class="spoc-account-nav-link{if $spoc_account_active == 'history'} active{/if}" href="{$urls.pages.history}">
        <i class="material-icons">&#xE916;</i>
        <span>{l s='Mes commandes' d='Shop.Theme.Customeraccount'}</span>
      </a>
    {/if}
    <a class="spoc-account-nav-link{if $spoc_account_active == 'identity'} active{/if}" href="{$urls.pages.identity}">
      <i class="material-icons">&#xE853;</i>
      <span>{l s='Paramètres de profil' d='Shop.Theme.Customeraccount'}</span>
    </a>
    {if $customer.addresses|count}
      <a class="spoc-account-nav-link{if $spoc_account_active == 'addresses' || $spoc_account_active == 'address'} active{/if}" href="{$urls.pages.addresses}">
        <i class="material-icons">&#xE56A;</i>
        <span>{l s='Adresses' d='Shop.Theme.Customeraccount'}</span>
      </a>
    {else}
      <a class="spoc-account-nav-link{if $spoc_account_active == 'addresses' || $spoc_account_active == 'address'} active{/if}" href="{$urls.pages.address}">
        <i class="material-icons">&#xE567;</i>
        <span>{l s='Ajouter une adresse' d='Shop.Theme.Customeraccount'}</span>
      </a>
    {/if}
    {if !$configuration.is_catalog}
      <a class="spoc-account-nav-link{if $spoc_account_active == 'order-slip'} active{/if}" href="{$urls.pages.order_slip}">
        <i class="material-icons">&#xE8B0;</i>
        <span>{l s='Avoirs' d='Shop.Theme.Customeraccount'}</span>
      </a>
    {/if}
    {if $configuration.voucher_enabled && !$configuration.is_catalog}
      <a class="spoc-account-nav-link{if $spoc_account_active == 'discount'} active{/if}" href="{$urls.pages.discount}">
        <i class="material-icons">&#xE54E;</i>
        <span>{l s='Bons de réduction' d='Shop.Theme.Customeraccount'}</span>
      </a>
    {/if}
    {if $configuration.return_enabled && !$configuration.is_catalog}
      <a class="spoc-account-nav-link{if $spoc_account_active == 'order-follow'} active{/if}" href="{$urls.pages.order_follow}">
        <i class="material-icons">&#xE860;</i>
        <span>{l s='Retours produit' d='Shop.Theme.Customeraccount'}</span>
      </a>
    {/if}
  </nav>
  <a class="spoc-account-logout" href="{if isset($logout_url)}{$logout_url}{else}{$urls.actions.logout}{/if}" rel="nofollow">
    <i class="material-icons">&#xE898;</i>
    <span>{l s='Déconnexion' d='Shop.Theme.Actions'}</span>
  </a>
</aside>
{/strip}
