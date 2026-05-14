{**
* 2007-2024 PrestaShop
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
* @copyright 2007-2024 PrestaShop SA
* @license https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
* International Registered Trademark & Property of PrestaShop SA
*}
{strip}
    {if $product.show_price}
    <div class="product-prices">
        {block name='product_discount'}
              {if $product.has_discount}
                <div class="product-discount">
                    {hook h='displayProductPriceBlock' product=$product type="old_price"}
                    <span class="regular-price">{l s='Regular price: ' d='Shop.Theme.Catalog'} {$product.regular_price}</span>
                </div>
              {/if}
        {/block}
        {block name='product_price'}
        <div class="product-price h5 {if $product.has_discount}has-discount{/if}" itemprop="offers" itemscope itemtype="https://schema.org/Offer">
            <link itemprop="availability" href="{$product.seo_availability}" />
            <meta itemprop="priceCurrency" content="{$currency.iso_code}">
            
            
            {if $product.has_discount}
                <div class="product-price-discount">
                <span class="product-price-discount" itemprop="price" content="{$product.price_amount}">{$product.price}</span>
                </div>

                {if $product.discount_type === 'percentage'}
                <span class="discount discount-percentage">
                  {l s='Save %percentage%' d='Shop.Theme.Catalog' sprintf=['%percentage%' => $product.discount_percentage_absolute]}
                </span>
                {else}
                <span class="discount discount-amount">
                    {l s='Save %amount%' d='Shop.Theme.Catalog' sprintf=['%amount%' => $product.discount_to_display]}
                </span>
                {/if}
            {else}
                <div class="current-price">
                <span class="price" itemprop="price" content="{$product.price_amount}">{$product.price}</span>
                </div>
            {/if}
               
            {block name='product_unit_price'}
            {if $displayUnitPrice}
            <p class="product-unit-price sub">{l s='(%unit_price%)' d='Shop.Theme.Catalog' sprintf=['%unit_price%' => $product.unit_price_full]}</p>
            {/if}
            {/block}
            

            {**if Configuration::get('PS_TAX')}
             *   <div class="tvproduct-tax-label">
             *       {if $configuration.taxes_enabled}
             *           {l s='Tax Included' d='Shop.Theme.Catalog'}
             *       {else}
             *           {l s='Tax Excluded' d='Shop.Theme.Catalog'}
             *       {/if}
             *   </div>
            {/if*}
        </div>
            {block name='product_availability'}
                {if $product.show_availability && ($product.availability_message || $product.availability == 'available')}
                    <span class="spoc-product-availability">
                        {if $product.availability == 'available'}
                            <i class="material-icons rtl-no-flip product-available">&#xE5CA;</i>
                        {elseif $product.availability == 'last_remaining_items'}
                            <i class="material-icons product-last-items">&#xE002;</i>
                        {else}
                            <i class="material-icons product-unavailable">&#xE14B;</i>
                        {/if}
                        {if $product.availability_message}
                            {$product.availability_message}
                        {elseif $product.availability == 'available'}
                            {l s='Produit en stock' d='Shop.Theme.Catalog'}
                        {/if}
                    </span>
                {/if}
            {/block}
            {if $product.show_quantities}
                <div class="product-quantities">
                <div class="label-stock">{l s='In stock' d='Shop.Theme.Catalog'}</div>
                </div>
            {/if}
            {if $product.delivery_information}
            <span class="delivery-information">{$product.delivery_information}</span>
            {/if}
            

        
        {/block}
        
        {block name='product_without_taxes'}
        {if $priceDisplay == 2}
        <p class="product-without-taxes">{l s='%price% tax excl.' d='Shop.Theme.Catalog' sprintf=['%price%' => $product.price_tax_exc]}</p>
        {/if}
        {/block}
        {**block name='product_pack_price'}
            *   {if $displayPackPrice}
            *    <p class="product-pack-price"><span>{l s='Instead of %price%' d='Shop.Theme.Catalog' sprintf=['%price%' => $noPackPrice]}</span></p>
            *    {/if}
        {/block*}
        {block name='product_ecotax'}
        {if $product.ecotax.amount > 0}
        <p class="price-ecotax">{l s='Including %amount% for ecotax' d='Shop.Theme.Catalog' sprintf=['%amount%' => $product.ecotax.value]}
            {if $product.has_discount}
            {l s='(not impacted by the discount)' d='Shop.Theme.Catalog'}
            {/if}
        </p>
        {/if}
        {/block}
        
        {hook h='displayProductPriceBlock' product=$product type="weight" hook_origin='product_sheet'}
        
    </div>
    {/if}
{/strip}
