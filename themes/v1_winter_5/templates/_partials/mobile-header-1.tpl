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
    <div id='tvcms-mobile-view-header' class="hidden-lg-up tvheader-mobile-layout mh1 mobile-header-1" data-header-mobile-layout="1">
        <div class="tvcmsmobile-top-wrapper">
            <div class='tvmobileheader-offer-wrapper col-sm-12'>
                {hook h='displayTopOfferText'}
            </div>
            {*<div class='tvmobileheader-language-currency-wrapper col-xl-6 col-lg-6 col-md-6 col-sm-12'>
                <div class="tvheader-language">{if $withData}{hook h='displayNavLanguageBlock'}{/if}</div>
                <div class="tvheader-currency">{if $withData}{hook h='displayNavCurrencyBlock'}{/if}</div>
            </div>*}
        </div>
        <div class='tvcmsmobile-header-menu-offer-text tvcmsheader-sticky'>
            <div class="tvcmsmobile-header-menu col-sm-1 col-xs-2">
                <div class="tvmobile-sliderbar-btn">
                    <a href="Javascript:void(0);" title="">
                        <i class='material-icons'>&#xe5d2;</i>
                    </a>
                </div>
                <div class="tvmobile-slidebar">
                    <div class="tvmobile-dropdown-close">
                        <a href="Javascript:void(0);"><i class='material-icons'>&#xe14c;</i></a>
                    </div>
                    <div id='tvmobile-megamenu'>
                        {if $withData}
                        {assign var=mm value={hook h='displayMegamenu'}}
                        {if $mm|trim == ''}
                        {assign var=mm value={hook h='displayNavFullWidth'}}
                        {/if}
                        {$mm nofilter}
                        {/if}
                    </div>

                    <div class="tvcmsmobile-contact">{if $withData}{hook h='displayNav1'}{/if}</div>
                    <div id='tvmobile-lang'>{if $withData}{hook h='displayNavLanguageBlock'}{/if}</div>
                    <div id='tvmobile-curr'>{if $withData}{hook h='displayNavCurrencyBlock'}{/if}</div>
                </div>
            </div>
            <div class="tvcmsmobile-header-logo-right-wrapper col-md-4 col-sm-12">
                <div id='tvcmsmobile-header-logo'>
                    {if $withData}
                    <a href="{$urls.base_url}" class="tv-header-logo">
                        <img class="logo img-responsive" src="{$shop.logo}" alt="{$shop.name}" height="34" width="200">
                    </a>
                    {/if}
                </div>
            </div>
            <div class="col-sm-7 col-xs-10 tvcmsmobile-cart-acount-text">
                <div id="tvcmsmobile-account-button">
                    {if $withData}
                    <div class="tvcms-header-myaccount">
                        <div class="tv-header-account">
                            <div class="tv-account-wrapper">
                                <button class="btn-unstyle tv-myaccount-btn tv-myaccount-btn-desktop" name="User Icon" aria-label="User Icon">
                                    <i class='material-icons'>&#xe897;</i>
                                    {* <svg version="1.1" id="Layer_1" x="0px" y="0px" width="31.377px" height="30.938px" viewBox="0 0 31.377 30.938" xml:space="preserve">
                                        <g>
                                            <path style="fill:none;stroke:#000000;stroke-width:0.6;stroke-miterlimit:10;" d="M15.666,17.321c7.626,0,13.904,5.812,14.837,13.316h0.525c-1.253-8.325-7.642-13.6-15.341-13.6c-7.698,0-14.088,5.274-15.339,13.6h0.48C1.764,23.134,8.041,17.321,15.666,17.321z"></path>
                                            <path style="fill:#FFD742;" d="M15.688,16.992c-4.494,0-8.15-3.654-8.15-8.148c0-4.497,3.656-8.152,8.15-8.152c4.497,0,8.15,3.655,8.15,8.152C23.839,13.338,20.186,16.992,15.688,16.992"></path>
                                            <circle style="fill:none;stroke:#000000;stroke-miterlimit:10;" cx="15.689" cy="8.838" r="8.338"></circle>
                                        </g>
                                    </svg> *}
                                    {* {if $customer.is_logged }
                                    <span class="tvcms_customer_name">{$customer.gender.name[$customer.gender.id]} {$customer.firstname} {$customer.lastname}</span>
                                    {else}
                                    <span>{l s='My Account' d='Shop.Theme.Catalog'}</span>
                                    {/if} *}
                                </button>
                                <ul class="dropdown-menu tv-account-dropdown tv-dropdown">
                                    {if $customer.is_logged }
                                    <li><a href="{$urls.pages.my_account}" class="tvmyccount"><i class="material-icons">person</i>{l s='My Account' d='Shop.Theme.Catalog'}</a></li>
                                    {/if}
                                    <li>{hook h='displayNavCustomerSignInBlock'}</li>
                                    <li>{hook h='displayNavWishlistBlock'}</li>
                                    <li>{hook h='displayNavProductCompareBlock'}</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    {/if}
                </div>
                <div id="tvmobile-cart">{if $withData}{hook h='displayNavShoppingCartBlock'}{/if}</div>
            </div>
        </div>
        <div class='tvcmsmobile-header-search-logo-wrapper'>
            <div class="tvcmsmobile-header-search col-md-12 col-sm-12">
                <div id="tvcmsmobile-search">{if $withData}{hook h='displayNavSearchBlock'}{/if}</div>
            </div>
        </div>
        {* <div class="tvcmsmobile-header-right">
            <div id='tvcmsmobile-horizontal-menu-left'></div>
        </div> *}
    </div>
    {/strip}