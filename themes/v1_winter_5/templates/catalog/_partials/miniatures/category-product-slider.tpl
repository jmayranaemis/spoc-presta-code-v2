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
    {block name='product_miniature_item'}
    <article class="item product-miniature js-product-miniature tvall-product-wrapper-info-box" data-id-product="{$product.id_product}" data-id-product-attribute="{$product.id_product_attribute}" itemscope itemtype="http://schema.org/Product">
        <div class="thumbnail-container">
            <div class="tvproduct-wrapper grid">
                {block name='product_thumbnail'}
                <div class="tvproduct-image">
                    {if $product.cover}
                    <a href="{$product.url}" class="thumbnail product-thumbnail">
                        <img src="{$product.cover.bySize['home_default']['url']}" alt="{if !empty($product.cover.legend)}{$product.cover.legend}{else}{$product.name}{/if}" class="tvproduct-defult-img tv-img-responsive" height="{$product.cover.bySize['home_default']['height']}" width="{$product.cover.bySize['home_default']['width']}" loading="lazy">
                        {if Configuration::get('TVCMSCUSTOMSETTING_HOVER_IMG')}
                        {if isset($product.images.0.bySize['home_default']['url']) && empty($product.images.0.cover)}
                        <img class="tvproduct-hover-img tv-img-responsive" src="{$product.images.0.bySize['home_default']['url']}" alt="{$product.name}" height="{$product.images.0.bySize['home_default']['height']}" width="{$product.images.0.bySize['home_default']['width']}" loading="lazy">
                        {elseif isset($product.images.1.bySize['home_default']['url']) && empty($product.images.1.cover)}
                        {if {Configuration::get('TVCMSCUSTOMSETTING_HOVER_IMG') != '0'}}
                        <img class="tvproduct-hover-img tv-img-responsive" src="{$product.images.1.bySize['home_default']['url']}" alt="{$product.name}" height="{$product.images.1.bySize['home_default']['height']}" width="{$product.images.1.bySize['home_default']['width']}" loading="lazy">
                        {/if}
                        {/if}
                        {/if}
                    </a>
                    {else}
                    <a href="{$product.url}" class="thumbnail product-thumbnail">
                        <img class="tv-img-responsive" src="{$ImgDir}{$iso_code}-default-home_default.jpg" />
                    </a>
                    {/if}
                    {block name='product_flags'}
                    <ul class="tvproduct-flags tvproduct-online-new-wrapper">
                        {foreach from=$product.flags item=flag}
                        {if $flag.type == 'online-only' || $flag.type == 'new'}
                        <li class="product-flag {$flag.type}">{$flag.label}</li>
                        {/if}
                        {/foreach}
                    </ul>
                    <ul class="tvproduct-flags tvproduct-sale-pack-wrapper">
                        {foreach from=$product.flags item=flag}
                        {if $flag.type == 'on-sale' || $flag.type == 'pack'}
                        <li class="product-flag {$flag.type}">{$flag.label}</li>
                        {/if}
                        {/foreach}
                    </ul>
                       {if $product.discount_type === 'percentage'}
                    <ul class="tvproduct-flags tvproduct-sale-pack-wrapper">
                        <li class="product-flag on-sale">{$product.discount_percentage}</li>
                    </ul>
                    {elseif $product.discount_type === 'amount'}
                    <span class="product-flag on-sale">{$product.discount_amount_to_display}</span>
                    {/if}
                    {/block}
                    {if !empty($product.specific_prices.from) && !empty($product.specific_prices.to) && $product.specific_prices.from != '0000-00-00 00:00:00' && $product.specific_prices.to != '0000-00-00 00:00:00'}
                    {include file='catalog/_partials/miniatures/product-timer.tpl' timer=$product.specific_prices.to}
                    {/if}
                    <div class="tvproduct-btn-color">
                        {if Configuration::get('TVCMSCUSTOMSETTING_PRODUCT_COLOR') == '1'}
                        {block name='product_variants'}
                        <div class='tvproduct-color'>
                            {if $product.main_variants}
                            {block name='product_variants'}
                            {assign var="isMore" value=4}
                            {assign var="colorCount" value=0}
                            {foreach from=$product.main_variants item=color_info}
                            {if $isMore == $colorCount && $isMore < count($product.main_variants)} <a href="javascript:void(0)" class='tvcmsmorecolor-icon'>
                                {(count($product.main_variants)-4)}
                                <i class='material-icons'>&#xe145;</i>
                                </a>
                                <span class="tvcmsmorecolor">
                                    {/if}
                                    {$colorCount = $colorCount+1}
                                    <div class="tvproduct-color-box-border" data-toggle="tvtooltip" data-placement="top" data-html="true" data-original-title="{$color_info.name}">
                                        <a href="{$color_info.url}" class='tvporoduct-color-box' style='{if $color_info.html_color_code != ""}background-color: {$color_info.html_color_code};{else}background-image: url({$color_info.texture});{/if}'>
                                        </a>
                                    </div>
                                    {/foreach}
                                    {if $isMore < $colorCount} <a href="javascript:void(0)" class='tvcmslesscolor-icon tvcmslesscolor-close'>
                                        <i class='material-icons'>&#xe15b;</i>
                                        </a>
                                </span>
                                {/if}
                                {/block}
                                {/if}
                        </div>
                        {/block}
                        {/if}
                        
                    </div>
                </div>
                {/block}
                <div class="tvproduct-info-box-wrapper">
                    <div class="product-description">
                        {* Start Product Comment *}
                        {hook h='displayReviewProductList' product=$product}
                        {* End Product Comment *}
                        {block name='product_name'}
                        <div class="tvproduct-name product-title">
                            {if !empty(Manufacturer::getnamebyid($product.id_manufacturer))}
                            <span class="brand-text-grid"><a href="{$link->getManufacturerLink($product.id_manufacturer)|escape:'html':'UTF-8'}">{Manufacturer::getnamebyid($product.id_manufacturer)|escape:'html':'UTF-8'}</a></span>
                            {else}
                            <span class="brand-text-grid">SPOC</span>
                            {/if}
                            <a href="{$product.url}">
                                <h6 itemprop="name">{$product.name|truncate:60:'...'}</h6>
                            </a>
                            <div class="tvproduct-cat-name">{$product.category_name}</div>
                        </div>
                        {/block}
                        <div class="tv-product-price">
                            <div class="tvproduct-name-price-wrapper">
                                {block name='product_price_and_shipping'}
                                {if $product.show_price}
                                <div class="product-price-and-shipping">
                                    {if $product.has_discount}
                                    <span class="product-grid-price-discount">{$product.price}</span>
                                    <span class="regular-price">{l s='Regular price: ' d='Shop.Theme.Catalog'} {$product.regular_price}</span>
                                    {else}
                                    <span class="product-grid-price">{$product.price}</span>
                                    {/if}
                                    {if $product.has_discount}
                                    {hook h='displayProductPriceBlock' product=$product type="old_price"}
                                    <span class="sr-only">{l s='Regular price' d='Shop.Theme.Catalog'}</span>
                                    {if $product.discount_type === 'percentage'}
                                    <span class="discount-percentage discount-product tvproduct-discount-price">{$product.discount_percentage}{l s=' off' d='Shop.Theme.Catalog'}</span>
                                    {elseif $product.discount_type === 'amount'}
                                    <span class="discount-amount discount-product tvproduct-discount-price">{$product.discount_amount_to_display} {l s=' off' d='Shop.Theme.Catalog'}</span>
                                    {/if}
                                    {/if}
                                    {hook h='displayProductPriceBlock' product=$product type="before_price"}
                                    <span class="sr-only">{l s='Price' d='Shop.Theme.Catalog'}</span>
                                    {hook h='displayProductPriceBlock' product=$product type='unit_price'}
                                    {hook h='displayProductPriceBlock' product=$product type='weight'}
                                </div>
                                {/if}
                                {/block}
                            </div>
                        </div>
                        {include file='catalog/_partials/miniatures/_stock-sizes-popup.tpl' product=$product}
                    </div>
                    <div class="tv-product-price-info-box">{*
                        Start Product Stock Indicator
                        *}<div class='tvcmsstock-indicator-wraper'>
                            {hook h='displayProductListStockIndicator' product=$product}
                        </div>{*
                        End Product Stock Indicator
                        *}{* {if Configuration::get('TVCMSCUSTOMSETTING_PRODUCT_COLOR') == '1'}
                        {block name='product_variants'}
                        {if $product.main_variants}
                        <div class="tvproduct-color">
                            {foreach from=$product.main_variants item=color_info}
                            <div class='tvproduct-color-wrapper'>
                                <a href="{$color_info.url}" title="{l s='Product color' d='Shop.Theme.Catalog'}">
                                    <div class="tvproduct-color-box-border">
                                        <div class='tvporoduct-color-box' style='{if $color_info.html_color_code != ""}background-color: {$color_info.html_color_code};{else}background-image: url({$color_info.texture});{/if}'></div>
                                    </div>
                                </a>
                            </div>
                            {/foreach}
                        </div>
                        {/if}
                        {/block}
                        {/if} *}
                    </div>
                </div>
            </div>
        </div>
    </article>
    {/block}
    {/strip}
