{**
 * 2007-2025 PrestaShop
 *}
{strip}

<div class="card cart-summary spoc-cart-summary-card spoc-checkout-summary-card">

  <div class="card-block spoc-cart-card-title spoc-cart-summary-heading">
    <h1 class="h1">{l s='Ma commande' d='Shop.Theme.Checkout'}</h1>
  </div>

  <div id="js-checkout-summary"
       class="js-cart spoc-checkout-summary-content"
       data-refresh-url="{$urls.pages.cart}?ajax=1&action=refresh">

    <div class="card-block spoc-checkout-summary-products-block">
      {block name='hook_checkout_summary_top'}
        {hook h='displayCheckoutSummaryTop'}
      {/block}

      {block name='cart_summary_products'}
        <div class="cart-summary-products spoc-checkout-summary-products">

          <p class="spoc-checkout-summary-count">{$cart.summary_string}</p>

          {block name='cart_summary_product_list'}
            <div id="cart-summary-product-list" class="spoc-checkout-summary-product-list">
              <ul class="media-list">
                {foreach from=$cart.products item=product}
                  <li class="media">
                    {include file='checkout/_partials/cart-summary-product-line.tpl' product=$product}
                  </li>
                {/foreach}
              </ul>
            </div>
          {/block}

        </div>
      {/block}

      {block name='cart_summary_subtotals'}
        <div class="spoc-cart-summary-lines spoc-checkout-summary-lines">
          {foreach from=$cart.subtotals item="subtotal"}
            {if $subtotal && $subtotal.type !== 'tax'}
              <div class="cart-summary-line cart-summary-subtotals" id="cart-subtotal-{$subtotal.type}">
                <span class="label">{$subtotal.label}</span>
                <span class="value">{$subtotal.value}</span>
              </div>
            {/if}
          {/foreach}
        </div>
      {/block}
    </div>

    {block name='cart_summary_voucher'}
      <div class="spoc-cart-voucher-wrapper spoc-checkout-voucher-wrapper">
        {include file='checkout/_partials/cart-voucher.tpl'}
      </div>
    {/block}

    {block name='cart_summary_totals'}
      <div class="spoc-cart-total-block spoc-checkout-total-block">
        {include file='checkout/_partials/cart-summary-totals.tpl' cart=$cart}
      </div>
    {/block}

  </div>

</div>

{/strip}