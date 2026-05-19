{**
 * SPOC - customer addresses list
 * Page: /fr/adresses
 * File: themes/v1_winter_5/templates/customer/addresses.tpl
 * address.tpl = form add/edit, addresses.tpl = list of saved addresses.
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
    <div class="spoc-account-address-list spoc-account-address-grid">
      {foreach $customer.addresses as $address}
        <div class="spoc-account-address-item">
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
{block name='page_footer'}
  {if !$spoc_is_account_child_page}
    {block name='my_account_links'}
      {include file='customer/_partials/my-account-links.tpl'}
    {/block}
  {/if}
{/block}

{/strip}
