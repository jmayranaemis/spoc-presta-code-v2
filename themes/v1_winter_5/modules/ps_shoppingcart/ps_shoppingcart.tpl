{**
* 2007-2025 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License 3.0 (AFL-3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* https://opensource.org/licenses/AFL-3.0
*
* @author PrestaShop SA <contact@prestashop.com>
* @copyright 2007-2025 PrestaShop SA
* @license https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
* International Registered Trademark & Property of PrestaShop SA
*}

{strip}

{assign var=cartProductsCount value=0}
{if isset($cart.products_count)}
    {assign var=cartProductsCount value=$cart.products_count}
{/if}

<div id="_desktop_cart">
    <div class="blockcart cart-preview {if $cartProductsCount > 0}active{else}inactive{/if} tv-header-cart" data-refresh-url="{$refresh_url}">
        <div class="tvheader-cart-wrapper {if Configuration::get('TVCMSCUSTOMSETTING_CART_VIEW') == 'pop-up'}tvheader-cart-wrapper-popup{/if}">

            <div class="tvheader-cart-btn-wrapper">
                <a rel="nofollow" href="javascript:void(0);" data-url="{$cart_url}" title="{l s='Cart' d='Shop.Theme.Checkout'}">
                    <div class="tvcart-icon-text-wrapper">
                        <div class="tv-cart-icon tvheader-right-icon tv-cart-icon-main">
                            <svg class="spoc-cart-icon" width="32" height="32" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                                <path d="M6.75 8.25h10.5l-.7 11.25H7.45L6.75 8.25Z" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linejoin="round"/>
                                <path d="M9 8.25V6.5a3 3 0 0 1 6 0v1.75" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round"/>
                            </svg>
                        </div>

                        <span class="spoc-cart-label">{l s='Cart' d='Shop.Theme.Checkout'}</span>

                        <div class="tv-cart-cart-inner">
                            <span class="cart-products-count">{$cartProductsCount}</span>
                        </div>
                    </div>
                </a>
            </div>

            {if Configuration::get('TVCMSCUSTOMSETTING_CART_VIEW') == 'classic'}

                <div class="ttvcmscart-show-dropdown-right">

                    {if $cartProductsCount > 0}

                        <div class="ttvcart-scroll-container">
                            <div class="ttvcart-close-title-count">
                                <button class="ttvclose-cart"></button>
                                <div class="ttvcart-top-title">
                                    <h4>{l s='Shopping Cart' d='Shop.Theme.Checkout'}</h4>
                                </div>
                                <div class="ttvcart-counter">
                                    <span class="ttvcart-products-count">{$cartProductsCount}</span>
                                </div>
                            </div>

                            <div class="ttvcart-product-content-box ttvscroll-container">
                                {if isset($cart.products) && $cart.products|count}
                                    {foreach from=$cart.products item=product}
                                        <div class="ttvcart-product-wrapper items">
                                            <div class="tvcart-product-list-img">
                                                <a href="{if isset($product.url)}{$product.url}{else}#{/if}" class="tvshoping-cart-dropdown-img-block">

                                                    {if isset($product.default_image.medium.url) && $product.default_image.medium.url}
                                                        <img
                                                            src="{$product.default_image.medium.url}"
                                                            {if isset($product.default_image.large.url)}data-full-size-image-url="{$product.default_image.large.url}"{/if}
                                                            title="{if isset($product.default_image.legend) && $product.default_image.legend}{$product.default_image.legend}{elseif isset($product.name)}{$product.name}{/if}"
                                                            alt="{if isset($product.default_image.legend) && $product.default_image.legend}{$product.default_image.legend}{elseif isset($product.name)}{$product.name}{/if}"
                                                            loading="lazy"
                                                            class="product-image"
                                                        >
                                                    {elseif isset($urls.no_picture_image.bySize.medium_default.url)}
                                                        <img
                                                            src="{$urls.no_picture_image.bySize.medium_default.url}"
                                                            alt="{if isset($product.name)}{$product.name}{/if}"
                                                            loading="lazy"
                                                            class="product-image"
                                                        >
                                                    {/if}

                                                </a>
                                            </div>

                                            <div class="tvcart-product-content">
                                                <div class="tvshoping-cart-dropdown-title">
                                                    <a href="{if isset($product.url)}{$product.url}{else}#{/if}">
                                                        <span class="product-name">{if isset($product.name)}{$product.name}{/if}</span>
                                                    </a>
                                                </div>

                                                <div class="tvcart-product-list-box">
                                                    <span class="tvshopping-cart-qty">{l s='QTY :' d='Shop.Theme.Actions'}</span>
                                                    <span class="product-qty">{if isset($product.quantity)}{$product.quantity}{else}0{/if}</span>
                                                </div>

                                                {if isset($product.price)}
                                                    <span class="product-price">{$product.price}</span>
                                                {/if}

                                                {if isset($product.has_discount) && $product.has_discount && isset($product.regular_price)}
                                                    <span class="regular-price">{$product.regular_price}</span>
                                                {/if}

                                                <div class="tvcart-product-remove">
                                                    {if isset($product.remove_from_cart_url)}
                                                        <a
                                                            class="remove-from-cart tvcmsremove-from-cart"
                                                            rel="nofollow"
                                                            href="{$product.remove_from_cart_url}"
                                                            data-link-action="delete-from-cart"
                                                            data-id-product="{if isset($product.id_product)}{$product.id_product|escape:'javascript'}{/if}"
                                                            data-id-product-attribute="{if isset($product.id_product_attribute)}{$product.id_product_attribute|escape:'javascript'}{/if}"
                                                            data-id-customization="{if isset($product.id_customization)}{$product.id_customization|escape:'javascript'}{/if}"
                                                            title="{l s='remove from cart' d='Shop.Theme.Actions'}"
                                                        >
                                                            <i class="material-icons">&#xe872;</i>
                                                        </a>
                                                    {/if}
                                                </div>

                                                {if isset($product.customizations) && $product.customizations|count}
                                                    <div class="customizations">
                                                        <ul>
                                                            {foreach from=$product.customizations item=customization}
                                                                <li>
                                                                    <span class="product-quantity">{if isset($customization.quantity)}{$customization.quantity}{/if}</span>

                                                                    {if isset($customization.remove_from_cart_url)}
                                                                        <a href="{$customization.remove_from_cart_url}" title="{l s='remove from cart' d='Shop.Theme.Actions'}" class="remove-from-cart" rel="nofollow">
                                                                            {l s='Remove' d='Shop.Theme.Actions'}
                                                                        </a>
                                                                    {/if}

                                                                    {if isset($customization.fields) && $customization.fields|count}
                                                                        <ul>
                                                                            {foreach from=$customization.fields item=field}
                                                                                <li>
                                                                                    <span>{if isset($field.label)}{$field.label}{/if}</span>

                                                                                    {if isset($field.type) && $field.type == 'text' && isset($field.text)}
                                                                                        <span>{$field.text nofilter}</span>
                                                                                    {elseif isset($field.type) && $field.type == 'image' && isset($field.image.small.url)}
                                                                                        <img src="{$field.image.small.url}" loading="lazy">
                                                                                    {/if}
                                                                                </li>
                                                                            {/foreach}
                                                                        </ul>
                                                                    {/if}
                                                                </li>
                                                            {/foreach}
                                                        </ul>
                                                    </div>
                                                {/if}
                                            </div>
                                        </div>
                                    {/foreach}
                                {/if}
                            </div>
                        </div>

                        <div class="ttvcart-price-shipping-text">

                            {if isset($cart.subtotals) && $cart.subtotals|count}
                                {foreach from=$cart.subtotals item=subtotal}
                                    {if isset($subtotal.value) && $subtotal.value && isset($subtotal.type) && $subtotal.type !== 'tax'}
                                        <div class="ttvcart-product-label-value" id="tvcart-subtotal-{$subtotal.type}">
                                            <span class="ttvshoping-cart-label label{if 'products' === $subtotal.type} js-subtotal{/if}">
                                                {if 'products' == $subtotal.type}
                                                    {l s='Sub Total' d='Shop.Theme.Checkout'}
                                                {elseif isset($subtotal.label)}
                                                    {$subtotal.label}
                                                {/if}

                                                {if $subtotal.type === 'shipping'}
                                                    <small class="value">{hook h='displayCheckoutSubtotalDetails' subtotal=$subtotal}</small>
                                                {/if}
                                            </span>

                                            <span class="ttvcart-product-value">{$subtotal.value}</span>
                                        </div>
                                    {/if}
                                {/foreach}
                            {/if}

                            {if isset($cart.totals.total)}
                                <div class="ttvcart-product-label-value total">
                                    <span class="ttvshoping-cart-label">
                                        {if isset($cart.totals.total.label)}{$cart.totals.total.label}{/if}
                                        {if isset($cart.labels.tax_short)} {$cart.labels.tax_short}{/if}
                                    </span>
                                    <span class="ttvcart-product-value">
                                        {if isset($cart.totals.total.value)}{$cart.totals.total.value}{/if}
                                    </span>
                                </div>
                            {/if}

                            {if isset($cart.subtotals.tax) && isset($cart.subtotals.tax.label) && isset($cart.subtotals.tax.value)}
                                <div class="ttvcart-product-label-value tax">
                                    <span class="ttvshoping-cart-label">{$cart.subtotals.tax.label}</span>
                                    <span class="ttvcart-product-value">{$cart.subtotals.tax.value}</span>
                                </div>
                            {/if}

                        </div>

                        <div class="ttvcart-product-list-btn-wrapper spoc-cart-actions">
                            <a class="ttvcart-product-list-viewcart spoc-cart-secondary" href="{$cart_url}">
                                {l s='View Cart' d='Shop.Theme.Actions'}
                            </a>
                        </div>

                    {else}

                        <div class="ttvcart-no-product">
                            <div class="ttvcart-close-title-count tdclose-btn-wrap">
                                <button class="ttvclose-cart"></button>
                                <div class="ttvcart-top-title">
                                    <h4>{l s='Shopping Cart' d='Shop.Theme.Checkout'}</h4>
                                </div>
                                <div class="ttvcart-counter">
                                    <span class="ttvcart-products-count">{$cartProductsCount}</span>
                                </div>
                            </div>
                        </div>

                    {/if}

                </div>

            {elseif Configuration::get('TVCMSCUSTOMSETTING_CART_VIEW') == 'pop-up'}

                <div class="tvcmscart-show-dropdown">

                    {if $cartProductsCount > 0}

                        <div class="tvcart-product-list">
                            <div class="tvcart-product-totle">
                                {l s='Your Cart: ' d='Shop.Theme.Checkout'}
                                {if isset($cart.products)}
                                    {$cart.products|count}
                                {else}
                                    0
                                {/if}
                                {if isset($cart.products) && $cart.products|count == 1}
                                    {l s='Item' d='Shop.Theme.Checkout'}
                                {else}
                                    {l s='Items' d='Shop.Theme.Checkout'}
                                {/if}
                            </div>

                            <div class="tvcart-product-content-box tvscroll-container">
                                {if isset($cart.products) && $cart.products|count}
                                    {foreach from=$cart.products item=product}
                                        <div class="tvcart-product-wrapper items">
                                            <div class="tvcart-product-list-img">
                                                <a href="{if isset($product.url)}{$product.url}{else}#{/if}" class="tvshoping-cart-dropdown-img-block">

                                                    {if isset($product.cover.bySize.cart_default.url) && $product.cover.bySize.cart_default.url}
                                                        <img
                                                            src="{$product.cover.bySize.cart_default.url}"
                                                            {if isset($product.cover.bySize.cart_default.width)}width="{$product.cover.bySize.cart_default.width}"{/if}
                                                            {if isset($product.cover.bySize.cart_default.height)}height="{$product.cover.bySize.cart_default.height}"{/if}
                                                            alt="{if isset($product.name)}{$product.name}{/if}"
                                                            loading="lazy"
                                                        >
                                                    {elseif isset($product.default_image.medium.url) && $product.default_image.medium.url}
                                                        <img
                                                            src="{$product.default_image.medium.url}"
                                                            alt="{if isset($product.name)}{$product.name}{/if}"
                                                            loading="lazy"
                                                        >
                                                    {elseif isset($urls.no_picture_image.bySize.medium_default.url)}
                                                        <img
                                                            src="{$urls.no_picture_image.bySize.medium_default.url}"
                                                            alt="{if isset($product.name)}{$product.name}{/if}"
                                                            loading="lazy"
                                                        >
                                                    {/if}

                                                </a>
                                            </div>

                                            <div class="tvcart-product-content">
                                                <div class="tvcart-product-list-quentity">
                                                    <div class="tvshoping-cart-dropdown-title">
                                                        <a href="{if isset($product.url)}{$product.url}{else}#{/if}">
                                                            <span class="product-name">{if isset($product.name)}{$product.name}{/if}</span>
                                                        </a>
                                                    </div>
                                                </div>

                                                <div class="tvcart-product-list-price">
                                                    <span class="product-quentity">{if isset($product.quantity)}{$product.quantity}{else}0{/if}</span>
                                                    <span class="tvshopping-cart-quentity">X</span>
                                                    {if isset($product.price)}
                                                        <span class="product-price">{$product.price}</span>
                                                    {/if}
                                                </div>

                                                <div class="tvcart-product-list-attribute">
                                                    {if isset($product.attributes) && $product.attributes|count}
                                                        {foreach from=$product.attributes key=prod_attb item=prod_val}
                                                            <div class="tvcart-product-attr">
                                                                <span>{$prod_attb}:</span> <span>{$prod_val}</span>
                                                            </div>
                                                        {/foreach}
                                                    {/if}
                                                </div>

                                                <div class="tvcart-product-remove">
                                                    {if isset($product.remove_from_cart_url)}
                                                        <a
                                                            class="remove-from-cart tvcmsremove-from-cart"
                                                            rel="nofollow"
                                                            href="{$product.remove_from_cart_url}"
                                                            data-link-action="delete-from-cart"
                                                            data-id-product="{if isset($product.id_product)}{$product.id_product|escape:'javascript'}{/if}"
                                                            data-id-product-attribute="{if isset($product.id_product_attribute)}{$product.id_product_attribute|escape:'javascript'}{/if}"
                                                            data-id-customization="{if isset($product.id_customization)}{$product.id_customization|escape:'javascript'}{/if}"
                                                            title="{l s='remove from cart' d='Shop.Theme.Actions'}"
                                                        >
                                                            <i class="material-icons">&#xe872;</i>
                                                        </a>
                                                    {/if}
                                                </div>

                                                {if isset($product.customizations) && $product.customizations|count}
                                                    <div class="customizations">
                                                        <ul>
                                                            {foreach from=$product.customizations item=customization}
                                                                <li>
                                                                    <span class="product-quantity">{if isset($customization.quantity)}{$customization.quantity}{/if}</span>

                                                                    {if isset($customization.remove_from_cart_url)}
                                                                        <a href="{$customization.remove_from_cart_url}" title="{l s='remove from cart' d='Shop.Theme.Actions'}" class="remove-from-cart" rel="nofollow">
                                                                            {l s='Remove' d='Shop.Theme.Actions'}
                                                                        </a>
                                                                    {/if}

                                                                    {if isset($customization.fields) && $customization.fields|count}
                                                                        <ul>
                                                                            {foreach from=$customization.fields item=field}
                                                                                <li>
                                                                                    <span>{if isset($field.label)}{$field.label}{/if}</span>

                                                                                    {if isset($field.type) && $field.type == 'text' && isset($field.text)}
                                                                                        <span>{$field.text nofilter}</span>
                                                                                    {elseif isset($field.type) && $field.type == 'image' && isset($field.image.small.url)}
                                                                                        <img src="{$field.image.small.url}" loading="lazy">
                                                                                    {/if}
                                                                                </li>
                                                                            {/foreach}
                                                                        </ul>
                                                                    {/if}
                                                                </li>
                                                            {/foreach}
                                                        </ul>
                                                    </div>
                                                {/if}
                                            </div>
                                        </div>
                                    {/foreach}
                                {/if}
                            </div>

                            <div class="tvcart-product-list-total-info">
                                <div class="tvcart-product-list-subtotal-prod">
                                    <span class="tvshoping-cart-subtotal">{l s='Sub Total' d='Shop.Theme.Checkout'}</span>
                                    <span class="tvcart-product-price">
                                        {if isset($cart.subtotals.products.value)}
                                            {$cart.subtotals.products.value}
                                        {elseif isset($cart.totals.total.value)}
                                            {$cart.totals.total.value}
                                        {/if}
                                    </span>
                                </div>
                            </div>
                        </div>

                        <div class="tvcart-product-list-btn-wrapper">
                            <div class="tvcart-product-list-viewcart">
                                <a href="{$cart_url}">{l s='View cart' d='Shop.Theme.Checkout'}</a>
                            </div>
                            <div class="tvcart-product-list-checkout">
                                <a href="javascript:void(0);" class="tvcart-product-list-checkout-link">
                                    {l s='Proceed to checkout' d='Shop.Theme.Checkout'}
                                </a>
                            </div>
                        </div>

                    {else}

                        <div class="tvcart-no-product">
                            <div class="tvcart-no-product-label">
                                {l s='No product add in cart' d='Shop.Theme.Checkout'}
                            </div>
                        </div>

                    {/if}

                </div>

            {/if}

        </div>
    </div>
</div>

{/strip}
