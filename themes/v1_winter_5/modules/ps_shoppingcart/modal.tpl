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
 * @author    PrestaShop SA <contact@prestashop.com>
 * @copyright 2007-2025 PrestaShop SA
 * @license   https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
 * International Registered Trademark & Property of PrestaShop SA
 *}
{strip}
<div id="blockcart-modal" class="modal fade tv-addtocart-msg-wrapper spoc-addtocart-modal" tabindex="-1" role="dialog" aria-labelledby="spocBlockcartModalTitle" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header spoc-addtocart-modal-header">
                <button type="button" class="close tv-addtocart-close spoc-addtocart-close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title h6" id="spocBlockcartModalTitle">
                    <i class="material-icons rtl-no-flip">&#xE876;</i>
                    <span>{l s='Produit ajouté au panier' d='Shop.Theme.Checkout'}</span>
                </h4>
            </div>

            <div class="modal-body tv-addtocart-content-part spoc-addtocart-modal-body">
                <div class="spoc-addtocart-product-row">
                    <div class="spoc-addtocart-product-image">
                        {if $product.default_image}
                            <img
                                src="{$product.default_image.medium.url}"
                                data-full-size-image-url="{$product.default_image.large.url}"
                                title="{$product.default_image.legend}"
                                alt="{$product.default_image.legend}"
                                loading="lazy"
                                class="product-image"
                            >
                        {else}
                            <img
                                src="{$urls.no_picture_image.bySize.medium_default.url}"
                                loading="lazy"
                                class="product-image"
                            >
                        {/if}
                    </div>

                    <div class="spoc-addtocart-product-info">
                        <p class="spoc-addtocart-kicker">{l s='Votre sélection' d='Shop.Theme.Checkout'}</p>
                        <h5 class="spoc-addtocart-product-name">{$product.name}</h5>

                        {if isset($product.attributes) && $product.attributes|count}
                            <div class="spoc-addtocart-attributes">
                                {foreach from=$product.attributes item="property_value" key="property"}
                                    <span class="spoc-addtocart-attribute">
                                        <span class="spoc-addtocart-attribute-label">{$property}</span>
                                        <strong>{$property_value}</strong>
                                    </span>
                                {/foreach}
                            </div>
                        {/if}

                        <div class="spoc-addtocart-meta">
                            <span>{l s='Quantité' d='Shop.Theme.Checkout'} : <strong>{$product.cart_quantity}</strong></span>
                        </div>
                    </div>
                </div>

                <div class="spoc-addtocart-actions">
                    <button type="button" class="spoc-addtocart-btn spoc-addtocart-btn-secondary" data-dismiss="modal">
                        {l s='Continuer mes achats' d='Shop.Theme.Actions'}
                    </button>

                    <a href="{$cart_url}" class="spoc-addtocart-btn spoc-addtocart-btn-primary">
                        {l s='Voir mon panier' d='Shop.Theme.Actions'}
                    </a>
                </div>

                <div class="spoc-addtocart-crossselling">
                    {widget name='ps_crossselling' hook='displayFooterProduct' product=$product}
                </div>
            </div>
        </div>
    </div>
</div>
{/strip}
