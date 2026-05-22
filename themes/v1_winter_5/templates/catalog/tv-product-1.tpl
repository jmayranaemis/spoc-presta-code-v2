{strip}
<div class="tvprduct-image-info-wrapper clearfix row product-1" data-product-layout="1">
    {hook h='displayProductTabVideo'}
    <div class="col-md-6 tv-product-page-image">
        {block name='product_cover_thumbnails'}
            {include file='catalog/_partials/product-cover-thumbnails.tpl'}
        {/block}
    </div>
    <div class="col-md-6 tv-product-page-content">
        <div class="tvproduct-title-brandimage" itemprop="itemReviewed" itemscope itemtype="http://schema.org/Thing">
            {block name='page_header_container'}
                {block name='page_header'}
                    {if !empty(Manufacturer::getnamebyid($product.id_manufacturer))}
                        <span class="brand-text">
                            <a href="{$link->getManufacturerLink($product.id_manufacturer)|escape:'html':'UTF-8'}">
                                {Manufacturer::getnamebyid($product.id_manufacturer)|escape:'html':'UTF-8'}
                            </a>
                        </span>
                    {else}
                        <span class="brand-text">SPOC</span>
                    {/if}
                    <h1 class="h1" itemprop="name">
                        {block name='page_title'}{$product.name}{/block}
                    </h1>
                {/block}
                {* Start Product Comment *}
                {hook h='displayReviewProductList' product=$product}
                {* End Product Comment *}
                {block name='product_features'}
                    {if $product.grouped_features}
                        <div class="product-features-page">
                            <dl class="data-sheet-product">
                                {foreach from=$product.grouped_features item=feature}
                                    {assign var='featureName' value=$feature.name|lower|replace:'é':'e'|replace:'è':'e'|replace:'ê':'e'|replace:'à':'a'}
                                    {assign var='featureIcon' value='done'}
                                    {if $featureName == 'saison'}
                                        {assign var='featureIcon' value='ac_unit'}
                                    {elseif $featureName == 'genre' || $featureName == 'sexe'}
                                        {assign var='featureIcon' value='person'}
                                    {elseif $featureName == 'niveau'}
                                        {assign var='featureIcon' value='trending_up'}
                                    {elseif $featureName == 'rayon'}
                                        {assign var='featureIcon' value='track_changes'}
                                    {elseif $featureName == 'programme'}
                                        {assign var='featureIcon' value='terrain'}
                                    {/if}
                                    <dd class="value-feature" aria-label="{$feature.name|escape:'htmlall'} : {$feature.value|escape:'htmlall'}">
                                        <span class="value-feature-icon" aria-hidden="true">
                                            <i class="material-icons">{$featureIcon|escape:'htmlall':'UTF-8'}</i>
                                        </span>
                                        <span class="value-feature-label sr-only">{$feature.name|escape:'htmlall'}</span>
                                        <span class="value-feature-text">{$feature.value|escape:'htmlall'|nl2br nofilter}</span>
                                    </dd>
                                {/foreach}
                            </dl>
                        </div>
                    {/if}
                {/block}
            {/block}
        </div>
        {block name='product_prices'}
            {include file='catalog/_partials/product-prices.tpl'}
        {/block}
        <div class="product-actions">
            {block name='product_buy'}
                <form action="{$urls.pages.cart}" method="post" id="add-to-cart-or-refresh">
                    <input type="hidden" name="token" value="{$static_token}">
                    <input type="hidden" name="id_product" value="{$product.id}" id="product_page_product_id">
                    <input type="hidden" name="id_customization" value="{$product.id_customization}" id="product_customization_id">
                    {block name='product_variants'}
                        {include file='catalog/_partials/product-variants.tpl'}
                    {/block}
                    {if $product.is_customizable && count($product.customizations.fields)}
                        {block name='product_customization'}
                            <div class="product-information tvproduct-special-desc">
                                {include file="catalog/_partials/product-customization.tpl" customizations=$product.customizations}
                            </div>
                        {/block}
                    {/if}
                    {block name='product_pack'}
                        {if $packItems}
                            <div class="product-pack">
                                <p class="h4">{l s='This pack contains' d='Shop.Theme.Catalog'}</p>
                                {foreach from=$packItems item="product_pack"}
                                    {block name='product_miniature'}
                                        {include file='catalog/_partials/miniatures/pack-product.tpl' product=$product_pack}
                                    {/block}
                                {/foreach}
                            </div>
                        {/if}
                    {/block}
                    {block name='product_discounts'}
                        {include file='catalog/_partials/product-discounts.tpl'}
                    {/block}
                    {block name='product_add_to_cart'}
                        {include file='catalog/_partials/product-add-to-cart.tpl'}
                    {/block}
                    <div class="tax-shipping-delivery-label">
                        {if $configuration.return_enabled}
                            {l s='Return policy:' d='Shop.Theme.Catalog'}{$configuration.number_of_days_for_return}
                        {/if}
                        <span>{$product.delivery_in_stock}</span>
                        {* {hook h='displayProductPriceBlock' product=$product type="price"} *}
                        {* {hook h='displayProductPriceBlock' product=$product type="after_price"} *}
                        {* {if $product.additional_delivery_times == 1} *}
                        {* {if $product.delivery_information} *}
                        {* <span class="delivery-information">{$product.delivery_information}</span> *}
                        {* {/if} *}
                        {* {elseif $product.additional_delivery_times == 2} *}
                        {* {if $product.quantity > 0} *}
                        {* <span class="delivery-information">{$product.delivery_in_stock}</span> *}
                        {* {elseif $product.quantity == 0 && $product.add_to_cart_url} *}
                        {* <span class="delivery-information">{$product.delivery_out_stock}</span> *}
                        {* {/if} *}
                        {* {/if} *}
                    </div>
                    {* Input to refresh product HTML removed, block kept for compatibility with themes *}
                    {block name='product_refresh'}{/block}
                </form>
            {/block}
        </div>
        {* On laisse ce hook hors du formulaire pour éviter les conflits si un module injecte un <form> *}
        {hook h='displayCustomtab'}
         {if !empty($product.specific_prices.from) && !empty($product.specific_prices.to) && $product.specific_prices.from != '0000-00-00 00:00:00' && $product.specific_prices.to != '0000-00-00 00:00:00'}
            {include file='catalog/_partials/miniatures/product-timer.tpl' timer=$product.specific_prices.to}
        {/if}
    </div>

    <div class="col-md-12 col-sm-12 col-xs-12 tv-product-reassurance-band">
        {block name='hook_display_reassurance'}
            {hook h='displayReassurance'}
        {/block}
    </div>
</div>
{/strip}
