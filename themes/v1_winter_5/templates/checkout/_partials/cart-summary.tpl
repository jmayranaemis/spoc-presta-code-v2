{**
 * 2007-2025 PrestaShop
 *}
{strip}

<div id="js-checkout-summary"
     class="card js-cart cart-summary spoc-cart-summary-card spoc-checkout-summary-card"
     data-refresh-url="{$urls.pages.cart}?ajax=1&action=refresh">

  <div class="card-block spoc-cart-card-title spoc-cart-summary-heading">
    <h1 class="h1">{l s='Ma commande' d='Shop.Theme.Checkout'}</h1>
  </div>

  <div class="spoc-checkout-summary-content">

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


    {block name='payment_confirmation'}
      <div id="payment-confirmation">
          <div class="ps-shown-by-js">
            <button type="submit" {if !$selected_payment_option} disabled {/if} class="tvall-inner-btn center-block">
              <span>{l s='Order with an obligation to pay' d='Shop.Theme.Checkout'}</span>
            </button>
            {if $show_final_summary}
              <article class="alert alert-danger mt-2 js-alert-payment-conditions" role="alert" data-alert="danger">
                {l
                  s='Please make sure you\'ve chosen a [1]payment method[/1] and accepted the [2]terms and conditions[/2].'
                  sprintf=[
                    '[1]' => '<a href="#checkout-payment-step">',
                    '[/1]' => '</a>',
                    '[2]' => '<a href="#conditions-to-approve">',
                    '[/2]' => '</a>'
                  ]
                  d='Shop.Theme.Checkout'
                }
              </article>
            {/if}
          </div>
          <div class="ps-hidden-by-js">
            {if $selected_payment_option and $all_conditions_approved}
              <label for="pay-with-{$selected_payment_option}">{l s='Order with an obligation to pay' d='Shop.Theme.Checkout'}</label>
            {/if}
          </div>
        </div>
     {/block}
  </div>

</div>

{/strip}