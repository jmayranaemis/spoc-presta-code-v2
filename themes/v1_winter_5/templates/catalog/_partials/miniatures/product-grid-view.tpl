{**
* 2007-2024 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License 3.0 (AFL-3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* https://opensource.org/licenses/AFL-3.0
*
* @author PrestaShop SA <contact@prestashop.com>
* @copyright 2007-2024 PrestaShop SA
* @license https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
* International Registered Trademark & Property of PrestaShop SA
*}

{strip}

{assign var=productClass value=''}
{if isset($class_name)}
    {assign var=productClass value=$class_name}
{/if}

{assign var=imageSize value='home_default'}
{if isset($image_size) && $image_size}
    {assign var=imageSize value=$image_size}
{/if}

{assign var=productUrl value='#'}
{if isset($product.url) && $product.url}
    {assign var=productUrl value=$product.url}
{/if}

{assign var=productName value=''}
{if isset($product.name) && $product.name}
    {assign var=productName value=$product.name}
{/if}

<div class="tvproduct-wrapper {$productClass}">

    {block name='product_thumbnail'}
        <div class="tvproduct-image">

            {if isset($product.cover.bySize[$imageSize]['url']) && $product.cover.bySize[$imageSize]['url']}

                <a href="{$productUrl}" class="thumbnail product-thumbnail" itemprop="url">
                    <img
                        src="{$product.cover.bySize[$imageSize]['url']}"
                        alt="{if isset($product.cover.legend) && $product.cover.legend}{$product.cover.legend}{else}{$productName}{/if}"
                        class="tvproduct-defult-img tv-img-responsive"
                        {if isset($product.cover.bySize[$imageSize]['height'])}height="{$product.cover.bySize[$imageSize]['height']}"{/if}
                        {if isset($product.cover.bySize[$imageSize]['width'])}width="{$product.cover.bySize[$imageSize]['width']}"{/if}
                        itemprop="image"
                        loading="lazy"
                    >

                    {if Configuration::get('TVCMSCUSTOMSETTING_HOVER_IMG')}

                        {if isset($product.images.0.bySize[$imageSize]['url']) && $product.images.0.bySize[$imageSize]['url'] && (!isset($product.images.0.cover) || empty($product.images.0.cover))}
                            <img
                                class="tvproduct-hover-img tv-img-responsive"
                                src="{$product.images.0.bySize[$imageSize]['url']}"
                                alt="{$productName}"
                                {if isset($product.images.0.bySize[$imageSize]['height'])}height="{$product.images.0.bySize[$imageSize]['height']}"{/if}
                                {if isset($product.images.0.bySize[$imageSize]['width'])}width="{$product.images.0.bySize[$imageSize]['width']}"{/if}
                                itemprop="image"
                                loading="lazy"
                            >
                        {elseif isset($product.images.1.bySize[$imageSize]['url']) && $product.images.1.bySize[$imageSize]['url'] && (!isset($product.images.1.cover) || empty($product.images.1.cover))}
                            <img
                                class="tvproduct-hover-img tv-img-responsive"
                                src="{$product.images.1.bySize[$imageSize]['url']}"
                                alt="{$productName}"
                                {if isset($product.images.1.bySize[$imageSize]['height'])}height="{$product.images.1.bySize[$imageSize]['height']}"{/if}
                                {if isset($product.images.1.bySize[$imageSize]['width'])}width="{$product.images.1.bySize[$imageSize]['width']}"{/if}
                                itemprop="image"
                                loading="lazy"
                            >
                        {/if}

                    {/if}
                </a>

            {else}

                <a href="{$productUrl}" class="thumbnail product-thumbnail">
                    {if isset($urls.no_picture_image.bySize[$imageSize]['url']) && $urls.no_picture_image.bySize[$imageSize]['url']}
                        <img
                            src="{$urls.no_picture_image.bySize[$imageSize]['url']}"
                            alt="{$productName}"
                            itemprop="image"
                            class="tv-img-responsive"
                            loading="lazy"
                        >
                    {elseif isset($urls.no_picture_image.bySize.home_default.url)}
                        <img
                            src="{$urls.no_picture_image.bySize.home_default.url}"
                            alt="{$productName}"
                            itemprop="image"
                            class="tv-img-responsive"
                            loading="lazy"
                        >
                    {elseif isset($ImgDir) && isset($iso_code)}
                        <img
                            src="{$ImgDir}{$iso_code}-default-home_default.jpg"
                            alt="{$productName}"
                            itemprop="image"
                            class="tv-img-responsive"
                            loading="lazy"
                        >
                    {/if}
                </a>

            {/if}

            {block name='product_flags'}

                {if isset($product.flags) && $product.flags|count}
                    <ul class="tvproduct-flags tvproduct-online-new-wrapper">
                        {foreach from=$product.flags item=flag}
                            {if isset($flag.type) && isset($flag.label) && ($flag.type == 'online-only' || $flag.type == 'new')}
                                <li class="product-flag {$flag.type}">{$flag.label}</li>
                            {/if}
                        {/foreach}
                    </ul>

                    <ul class="tvproduct-flags tvproduct-sale-pack-wrapper">
                        {foreach from=$product.flags item=flag}
                            {if isset($flag.type) && $flag.type == 'on-sale'}
                                <li class="product-flag {$flag.type}">
                                    {if isset($product.discount_percentage) && $product.discount_percentage}
                                        {$product.discount_percentage}
                                    {elseif isset($flag.label)}
                                        {$flag.label}
                                    {/if}
                                </li>
                            {/if}
                        {/foreach}
                    </ul>
                {/if}

                {if isset($product.condition.type) && $product.condition.type == 'used'}
                    <ul class="tvproduct-flags tvproduct-used-wrapper">
                        <li class="product-flag {$product.condition.type}">
                            {if isset($product.condition.label) && $product.condition.label}
                                {$product.condition.label}
                            {else}
                                {l s='Used' d='Shop.Theme.Catalog'}
                            {/if}
                        </li>
                    </ul>
                {/if}

                {if isset($product.discount_type) && $product.discount_type === 'percentage' && isset($product.discount_percentage) && $product.discount_percentage}
                    <ul class="tvproduct-flags tvproduct-sale-pack-wrapper">
                        <li class="product-flag on-sale">{$product.discount_percentage}</li>
                    </ul>
                {elseif isset($product.discount_type) && $product.discount_type === 'amount' && isset($product.discount_amount_to_display) && $product.discount_amount_to_display}
                    <span class="product-flag on-sale">{$product.discount_amount_to_display}</span>
                {/if}

            {/block}

            {if isset($product.specific_prices.from)
                && isset($product.specific_prices.to)
                && !empty($product.specific_prices.from)
                && !empty($product.specific_prices.to)
                && $product.specific_prices.from != '0000-00-00 00:00:00'
                && $product.specific_prices.to != '0000-00-00 00:00:00'
            }
                {include file='catalog/_partials/miniatures/product-timer.tpl' timer=$product.specific_prices.to}
            {/if}

            <div class="tvproduct-btn-color">
                {if Configuration::get('TVCMSCUSTOMSETTING_PRODUCT_COLOR') == '1'}
                    {block name='product_variants'}
                        <div class="tvproduct-color">
                            {if isset($product.main_variants) && $product.main_variants|count}

                                {assign var="isMore" value=4}
                                {assign var="colorCount" value=0}
                                {assign var="variantCount" value=$product.main_variants|count}

                                {foreach from=$product.main_variants item=color_info}

                                    {if $colorCount == $isMore && $isMore < $variantCount}
                                        <a href="javascript:void(0)" class="tvcmsmorecolor-icon">
                                            {$variantCount-$isMore}
                                            <i class="material-icons">&#xe145;</i>
                                        </a>
                                        <span class="tvcmsmorecolor">
                                    {/if}

                                    <div
                                        class="tvproduct-color-box-border"
                                        data-toggle="tvtooltip"
                                        data-placement="top"
                                        data-html="true"
                                        data-original-title="{if isset($color_info.name)}{$color_info.name}{/if}"
                                    >
                                        <a
                                            href="{if isset($color_info.url) && $color_info.url}{$color_info.url}{else}javascript:void(0){/if}"
                                            class="tvporoduct-color-box"
                                            style="{if isset($color_info.html_color_code) && $color_info.html_color_code != ''}background-color: {$color_info.html_color_code};{elseif isset($color_info.texture) && $color_info.texture != ''}background-image: url({$color_info.texture});{/if}"
                                        >
                                        </a>
                                    </div>

                                    {assign var="colorCount" value=$colorCount+1}

                                {/foreach}

                                {if $isMore < $colorCount}
                                        <a href="javascript:void(0)" class="tvcmslesscolor-icon tvcmslesscolor-close">
                                            <i class="material-icons">&#xe15b;</i>
                                        </a>
                                    </span>
                                {/if}

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
            {hook h='displayReviewProductList' product=$product productType=$productClass}
            {* End Product Comment *}

            {block name='product_name'}
                <div class="tvproduct-name product-title">

                    {assign var=manufacturerName value=''}
                    {if isset($product.id_manufacturer) && $product.id_manufacturer}
                        {assign var=manufacturerName value=Manufacturer::getnamebyid($product.id_manufacturer)}
                    {/if}

                    {if isset($manufacturerName) && !empty($manufacturerName)}
                        <span class="brand-text-grid">
                            {if isset($link)}
                                <a href="{$link->getManufacturerLink($product.id_manufacturer)|escape:'html':'UTF-8'}">
                                    {$manufacturerName|escape:'html':'UTF-8'}
                                </a>
                            {else}
                                {$manufacturerName|escape:'html':'UTF-8'}
                            {/if}
                        </span>
                    {else}
                        <span class="brand-text-grid">SPOC</span>
                    {/if}

                    <a href="{$productUrl}">
                        <h6 itemprop="name">{$productName|truncate:60:'...'}</h6>
                    </a>
                </div>
            {/block}

            {block name='product_price_and_shipping'}
                <div class="tv-product-price tvproduct-name-price-wrapper">
                    {if isset($product.show_price) && $product.show_price}
                        <div class="product-price-and-shipping">

                            {if isset($product.reference) && $product.reference}
                                <meta itemprop="sku" content="{$product.reference|escape:'html':'UTF-8'}" />
                                <meta itemprop="mpn" content="{$product.reference|escape:'html':'UTF-8'}" />
                            {/if}

                            {if isset($manufacturerName) && !empty($manufacturerName)}
                                <meta itemprop="brand" content="{$manufacturerName|escape:'html':'UTF-8'}" />
                            {/if}

                            {if isset($product.has_discount) && $product.has_discount}

                                {if isset($product.price)}
                                    <span class="product-grid-price-discount">{$product.price}</span>
                                {/if}

                                {if isset($product.regular_price)}
                                    <span class="regular-price">
                                        {l s='Regular price: ' d='Shop.Theme.Catalog'} {$product.regular_price}
                                    </span>
                                {/if}

                            {else}

                                {if isset($product.price)}
                                    <span class="product-grid-price">{$product.price}</span>
                                {/if}

                            {/if}

                            {if isset($product.has_discount) && $product.has_discount}

                                {hook h='displayProductPriceBlock' product=$product type="old_price"}

                                <span class="sr-only">{l s='Regular price' d='Shop.Theme.Catalog'}</span>

                                {if isset($product.discount_type) && $product.discount_type === 'percentage' && isset($product.discount_percentage)}
                                    <span class="discount-percentage discount-product tvproduct-discount-price">
                                        {$product.discount_percentage}{l s=' off' d='Shop.Theme.Catalog'}
                                    </span>
                                {elseif isset($product.discount_type) && $product.discount_type === 'amount' && isset($product.discount_amount_to_display)}
                                    <span class="discount-amount discount-product tvproduct-discount-price">
                                        {$product.discount_amount_to_display} {l s=' off' d='Shop.Theme.Catalog'}
                                    </span>
                                {/if}

                            {/if}

                            {hook h='displayProductPriceBlock' product=$product type="before_price"}

                            <span class="sr-only">{l s='Price' d='Shop.Theme.Catalog'}</span>

                            {hook h='displayProductPriceBlock' product=$product type='unit_price'}
                            {hook h='displayProductPriceBlock' product=$product type='weight'}

                        </div>
                    {/if}
                </div>
            {/block}

            {if isset($spoc_stock_sizes) && $spoc_stock_sizes && $spoc_stock_sizes|count}
                <div class="spoc-grid-stock-popup" aria-hidden="true">
                    <div class="spoc-grid-stock-title">{l s='Tailles disponibles' d='Shop.Theme.Catalog'}</div>
                    <ul class="spoc-grid-stock-list">
                        {foreach from=$spoc_stock_sizes item=stock_size}
                            <li class="spoc-grid-stock-size">{$stock_size.name|escape:'html':'UTF-8'}</li>
                        {/foreach}
                    </ul>
                </div>
            {/if}

        </div>
    </div>

</div>

{/strip}
