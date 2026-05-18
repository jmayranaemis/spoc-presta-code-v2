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
{extends file='page.tpl'}

{block name='notifications'}{/block}

{block name='page_content_container'}
  <section id="content" class="page-content">
    {block name='page_content_top'}
      {block name='customer_notifications'}
        {include file='_partials/notifications.tpl'}
      {/block}
    {/block}
    {if $page.page_name == 'identity' || $page.page_name == 'history' || $page.page_name == 'addresses' || $page.page_name == 'address' || $page.page_name == 'order-slip' || $page.page_name == 'discount' || $page.page_name == 'order-follow'}
      <style>
        body.page-customer-account .spoc-account-child-dashboard {
          display: grid !important;
          grid-template-columns: 260px minmax(0, 1fr) !important;
          gap: 36px !important;
          align-items: start !important;
        }

        body.page-customer-account .spoc-account-child-dashboard .spoc-account-sidebar {
          display: flex !important;
          flex-direction: column !important;
          grid-column: auto !important;
          width: auto !important;
          min-width: 0 !important;
          visibility: visible !important;
          opacity: 1 !important;
        }

        body.page-customer-account .spoc-account-child-dashboard .spoc-account-main {
          display: block !important;
          grid-column: auto !important;
          min-width: 0 !important;
        }

        body.page-customer-account .spoc-account-address-list,
        body.page-customer-account .spoc-account-address-grid {
          display: grid !important;
          grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
          gap: 20px !important;
          margin: 0 !important;
        }

        body.page-customer-account .spoc-account-address-item,
        body.page-customer-account .spoc-account-address-grid > [class*="col-"] {
          display: flex !important;
          width: auto !important;
          max-width: none !important;
          min-width: 0 !important;
          padding: 0 !important;
          margin: 0 !important;
          float: none !important;
        }

        @media (max-width: 1199px) {
          body.page-customer-account .spoc-account-child-dashboard {
            grid-template-columns: 230px minmax(0, 1fr) !important;
            gap: 24px !important;
          }
        }

        @media (max-width: 767px) {
          body.page-customer-account .spoc-account-child-dashboard {
            display: block !important;
          }

          body.page-customer-account .spoc-account-address-list,
          body.page-customer-account .spoc-account-address-grid {
            grid-template-columns: 1fr !important;
          }
        }
      </style>
      <div class="spoc-account-dashboard spoc-account-child-dashboard">
        {include file='customer/_partials/account-sidebar.tpl' spoc_account_active=$page.page_name}

        <div class="spoc-account-main">
          <section class="spoc-account-hero spoc-account-page-hero">
            <div>
              <p class="spoc-account-eyebrow">{l s='Espace client' d='Shop.Theme.Customeraccount'}</p>
              <h1>{block name='page_title'}{/block}</h1>
              <p>
                {if $page.page_name == 'identity'}
                  {l s='Gérez vos coordonnées, votre mot de passe et les préférences liées à votre compte.' d='Shop.Theme.Customeraccount'}
                {elseif $page.page_name == 'history'}
                  {l s='Consultez vos commandes, leurs statuts, vos factures et les détails de chaque achat.' d='Shop.Theme.Customeraccount'}
                {elseif $page.page_name == 'addresses' || $page.page_name == 'address'}
                  {l s='Tenez à jour vos adresses de livraison et de facturation pour vos prochaines commandes.' d='Shop.Theme.Customeraccount'}
                {elseif $page.page_name == 'order-slip'}
                  {l s='Retrouvez les avoirs générés après une annulation ou un remboursement.' d='Shop.Theme.Customeraccount'}
                {elseif $page.page_name == 'discount'}
                  {l s='Consultez vos bons de réduction disponibles, leurs conditions et leurs dates de validité.' d='Shop.Theme.Customeraccount'}
                {elseif $page.page_name == 'order-follow'}
                  {l s='Suivez vos demandes de retour produit et retrouvez les documents associés.' d='Shop.Theme.Customeraccount'}
                {/if}
              </p>
            </div>
          </section>

          <section class="spoc-account-section spoc-account-page-panel">
            {block name='page_content'}
              <!-- Page content -->
            {/block}
          </section>
        </div>
      </div>
    {else}
      {block name='page_content'}
        <!-- Page content -->
      {/block}
      {block name='customer_page_bottom_banners'}
        {if isset($page.page_name) && $page.page_name == 'my-account'}
          {capture assign='spoc_account_reassurance'}{hook h='displayFooterProduct' mod='blockreassurance'}{/capture}
          {if $spoc_account_reassurance|trim == ''}
            {capture assign='spoc_account_reassurance'}{hook h='displayNav1' mod='blockreassurance'}{/capture}
          {/if}
          {capture assign='spoc_account_newsletter'}{hook h='displayFooterProduct' mod='ps_emailsubscription'}{/capture}
          {if $spoc_account_newsletter|trim == ''}
            {capture assign='spoc_account_newsletter'}{hook h='displayNewslettersubscription' mod='ps_emailsubscription'}{/capture}
          {/if}
          {if $spoc_account_reassurance|trim != '' || $spoc_account_newsletter|trim != ''}
            <div class="spoc-account-bottom-banners">
              {if $spoc_account_reassurance|trim != ''}
                <div class="spoc-account-reassurance">
                  {$spoc_account_reassurance nofilter}
                </div>
              {/if}
              {if $spoc_account_newsletter|trim != ''}
                <div class="spoc-account-newsletter">
                  {$spoc_account_newsletter nofilter}
                </div>
              {/if}
            </div>
          {/if}
        {/if}
      {/block}
    {/if}
  </section>
{/block}

{block name='page_footer'}
  {if $page.page_name != 'identity' && $page.page_name != 'history' && $page.page_name != 'addresses' && $page.page_name != 'address' && $page.page_name != 'order-slip' && $page.page_name != 'discount' && $page.page_name != 'order-follow'}
    {block name='my_account_links'}
      {include file='customer/_partials/my-account-links.tpl'}
    {/block}
  {/if}
{/block}
{/strip}
