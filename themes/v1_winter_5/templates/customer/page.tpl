{**
 * 2007-2025 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License 3.0 (AFL-3.0).
 *
 * @author    PrestaShop SA <contact@prestashop.com>
 * @copyright 2007-2025 PrestaShop SA
 * @license   https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
 * International Registered Trademark & Property of PrestaShop SA
 *}

{strip}
{extends file='page.tpl'}

{assign var='spoc_is_account_child_page' value=false}

{if isset($page.page_name)}
  {if $page.page_name == 'identity'
    || $page.page_name == 'history'
    || $page.page_name == 'addresses'
    || $page.page_name == 'address'
    || $page.page_name == 'order-slip'
    || $page.page_name == 'discount'
    || $page.page_name == 'order-follow'}
    {assign var='spoc_is_account_child_page' value=true}
  {/if}
{/if}

{block name='notifications'}{/block}

{block name='page_content_container'}
  <section id="content" class="page-content">

    {block name='page_content_top'}
      {block name='customer_notifications'}
        {include file='_partials/notifications.tpl'}
      {/block}
    {/block}

    {if $spoc_is_account_child_page}

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

    {/if}

  </section>
{/block}

{block name='page_footer'}
  {if !$spoc_is_account_child_page}
    {block name='my_account_links'}
      {include file='customer/_partials/my-account-links.tpl'}
    {/block}
  {/if}
{/block}
{/strip}