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
* @author PrestaShop SA <contact@prestashop.com>
* @copyright 2007-2025 PrestaShop SA
* @license https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
* International Registered Trademark & Property of PrestaShop SA
*}
{strip}
<div class="product-line-grid spoc-cart-product-line">

    <div class="spoc-cart-product-main">
        <span class="product-image media-middle spoc-cart-product-image">
            <img src="{$product.cover.bySize.cart_default.url}" alt="{$product.name|escape:'quotes':'UTF-8'}" loading="lazy">
        </span>

        <div class="spoc-cart-product-info">
            <div class="product-line-info">
                <div class="tvproduct-name">
                    <div class="product-title">
                        <a href="{$product.url}" data-id_customization="{$product.id_customization|intval}">
                            <h6>{$product.name}</h6>
                        </a>
                    </div>
                </div>
            </div>

            {foreach from=$product.attributes key="attribute" item="value"}
                <div class="product-line-info spoc-cart-attribute">
                    <span class="label">{$attribute} : </span>
                    <span class="value">{$value}</span>
                </div>
            {/foreach}

            {if $product.unit_price_full}
                <div class="unit-price-cart spoc-cart-unit-detail">{$product.unit_price_full}</div>
            {/if}

            {if $product.customizations|count}
                {block name='cart_detailed_product_line_customization'}
                    {foreach from=$product.customizations item="customization"}
                        <a class="spoc-cart-customization-link" href="#" data-toggle="modal" data-target="#product-customizations-modal-{$customization.id_customization}">{l s='Product customization' d='Shop.Theme.Catalog'}</a>
                        <div class="modal fade customization-modal" id="product-customizations-modal-{$customization.id_customization}" tabindex="-1" role="dialog" aria-hidden="true">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                        <h4 class="modal-title">{l s='Product customization' d='Shop.Theme.Catalog'}</h4>
                                    </div>
                                    <div class="modal-body">
                                        {foreach from=$customization.fields item="field"}
                                            <div class="product-customization-line row">
                                                <div class="col-sm-3 col-xs-4 label">
                                                    {$field.label}
                                                </div>
                                                <div class="col-sm-9 col-xs-8 value">
                                                    {if $field.type == 'text'}
                                                        {if (int)$field.id_module}
                                                            {$field.text nofilter}
                                                        {else}
                                                            {$field.text}
                                                        {/if}
                                                    {elseif $field.type == 'image'}
                                                        <img src="{$field.image.small.url}">
                                                    {/if}
                                                </div>
                                            </div>
                                        {/foreach}
                                    </div>
                                </div>
                            </div>
                        </div>
                    {/foreach}
                {/block}
            {/if}
        </div>
    </div>

    <div class="spoc-cart-qty-col">
        <span class="spoc-cart-mobile-label">{l s='Qté' d='Shop.Theme.Checkout'}</span>
        {if isset($product.is_gift) && $product.is_gift}
            <span class="gift-quantity">{$product.quantity}</span>
        {else}
            <input class="js-cart-line-product-quantity form-control" data-down-url="{$product.down_quantity_url}" data-up-url="{$product.up_quantity_url}" data-update-url="{$product.update_quantity_url}" data-product-id="{$product.id_product}" type="text" value="{$product.quantity}" name="product-quantity-spin" min="{$product.minimal_quantity}" />
        {/if}
    </div>

    <div class="spoc-cart-unit-col product-price-and-shipping product-line-info {if $product.has_discount}has-discount{/if}">
        <span class="spoc-cart-mobile-label">{l s='Prix unitaire' d='Shop.Theme.Checkout'}</span>
        <span class="price">{$product.price}</span>
        {if $product.has_discount}
            <span class="regular-price">{$product.regular_price}</span>
            {if $product.discount_type === 'percentage'}
                <span class="discount discount-percentage tvproduct-discount-price">-{$product.discount_percentage_absolute}</span>
            {else}
                <span class="discount discount-amount tvproduct-discount-price">-{$product.discount_to_display}</span>
            {/if}
        {/if}
    </div>

    <div class="spoc-cart-total-col">
        <span class="spoc-cart-mobile-label">{l s='Total' d='Shop.Theme.Checkout'}</span>
        <span class="product-price">
            <strong>
                {if isset($product.is_gift) && $product.is_gift}
                    <span class="gift">{l s='Gift' d='Shop.Theme.Checkout'}</span>
                {else}
                    {$product.total}
                {/if}
            </strong>
        </span>
    </div>

    <div class="spoc-cart-delete-col">
        <div class="cart-line-product-actions">
            <a class="remove-from-cart" rel="nofollow" href="{$product.remove_from_cart_url}" data-link-action="delete-from-cart" data-id-product="{$product.id_product|escape:'javascript':'UTF-8'}" data-id-product-attribute="{$product.id_product_attribute|escape:'javascript':'UTF-8'}" data-id-customization="{$product.id_customization|escape:'javascript':'UTF-8'}" aria-label="{l s='Remove product from cart' d='Shop.Theme.Actions'}">
                {if !isset($product.is_gift) || !$product.is_gift}
                    <i class="material-icons">delete</i>
                {/if}
            </a>
            {block name='hook_cart_extra_product_actions'}
                {hook h='displayCartExtraProductActions' product=$product}
            {/block}
        </div>
    </div>

</div>
{/strip}
