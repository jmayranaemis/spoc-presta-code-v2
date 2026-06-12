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
    <div id='tvcms-mobile-view-header' class="hidden-lg-up tvheader-mobile-layout mh3 mobile-header-2 mobile-header-3" data-header-mobile-layout="3">
        <div class="tvcmsmobile-top-wrapper">
            <div class='tvmobileheader-offer-wrapper col-sm-12'>
                {hook h='displayTopOfferText'}
            </div>
            {*<div class='tvmobileheader-language-currency-wrapper col-xl-6 col-lg-6 col-md-6 col-sm-12'>
                <div class="tvheader-language">{if $withData}{hook h='displayNavLanguageBlock'}{/if}</div>
                <div class="tvheader-currency">{if $withData}{hook h='displayNavCurrencyBlock'}{/if}</div>
            </div>*}
        </div>
        <div class='tvcmsmobile-header-search-logo-wrapper tvcmsheader-sticky'>
            <div class="tvcmsmobile-header-logo-right-wrapper col-md-12 col-sm-12">
                <div id='tvcmsmobile-header-logo'>
                    {if $withData}
                    <a href="{$urls.base_url}" class="tv-header-logo">
                        <img class="logo img-responsive" src="{$shop.logo}" alt="{$shop.name}" height="34" width="200">
                    </a>
                    {/if}
                </div>
            </div>
            <div class="tvcmsmobile-header-menu col-md-4 col-sm-12">
                <div class="tvmobile-sliderbar-btn">
                    <a href="Javascript:void(0);" title=""><i class='material-icons'>&#xe5d2;</i></a>
                </div>
                <div class="tvmobile-slidebar">
                    <div class="tvmobile-dropdown-close">
                        <a href="Javascript:void(0);"><i class='material-icons'>&#xe14c;</i></a>
                    </div>
                    <div id='tvmobile-megamenu'>
                        {if $withData}{hook h='displayMegamenu'}{/if}
                    </div>
                    <div class="tvcmsmobile-contact">{if $withData}{hook h='displayNav1'}{/if}</div>
                    <div id='tvmobile-lang'>{if $withData}{hook h='displayNavLanguageBlock'}{/if}</div>
                    <div id='tvmobile-curr'>{if $withData}{hook h='displayNavCurrencyBlock'}{/if}</div>
                </div>
                <div class="modal-backdrop-menu"></div>
            </div>
            <div class="tvcmsmobile-header-search col-md-8 col-sm-12">
                <div class="tvmobile-search-icon">
                    <div class="tvheader-sarch-display">
                        <div class="tvheader-search-display-icon">
                            <div class="tvsearch-open">
                                <i class="material-icons">&#xe8b6;</i>
                                {* <svg version="1.1" id="Layer_1" x="0px" y="0px" width="30px" height="30px" viewBox="0 0 30 30" xml:space="preserve">
                                    <g>
                                        <polygon points="29.245,30 21.475,22.32 22.23,21.552 30,29.232  " />
                                        <circle style="fill:#FFD741;" cx="13" cy="13" r="12.1" />
                                        <circle style="fill:none;stroke:#000000;stroke-miterlimit:10;" cx="13" cy="13" r="12.5" />
                                    </g>
                                </svg> *}
                            </div>
                            <div class="tvsearch-close">
                                <i class='material-icons'>&#xe5cd;</i>
                                {* <svg version="1.1" id="Layer_1" x="0px" y="0px" width="24px" height="24px" viewBox="0 0 20 20" xml:space="preserve">
                                    <g>
                                        <rect x="9.63" y="-3.82" transform="matrix(0.7064 -0.7078 0.7078 0.7064 -4.1427 10.0132)" width="1" height="27.641"></rect>
                                    </g>
                                    <g>
                                        <rect x="9.63" y="-3.82" transform="matrix(-0.7064 -0.7078 0.7078 -0.7064 9.9859 24.1432)" width="1" height="27.641"></rect>
                                    </g>
                                </svg> *}
                            </div>
                        </div>
                    </div>
                </div>
                <div id="tvcmsmobile-account-button">
                    {if $withData}
                    <div class="tvcms-header-myaccount">
                        <div class="tv-header-account">
                            <div class="tv-account-wrapper">
                                <button class="btn-unstyle tv-myaccount-btn tv-myaccount-btn-desktop" name="User Icon" aria-label="User Icon">
                                    <svg class="spoc-account-icon" width="28" height="28" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                                        <circle cx="12" cy="7.75" r="3.25" fill="none" stroke="currentColor" stroke-width="1.8"/>
                                        <path d="M5.5 20c.9-4.3 3.2-6.5 6.5-6.5s5.6 2.2 6.5 6.5" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
                                    </svg>
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
                                    <li class="tvmobile-account">{hook h='displayNavCustomerSignInBlock'}</li>
                                    <li class="tvmobile-wishlist">{hook h='displayNavWishlistBlock'}</li>
                                    <li class="tvmobile-compare">{hook h='displayNavProductCompareBlock'}</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    {/if}
                </div>
                <div id="tvmobile-cart">{if $withData}{hook h='displayNavShoppingCartBlock'}{/if}</div>
            </div>
            <div id="tvcmsmobile-search">{if $withData}{hook h='displayNavSearchBlock'}{/if}</div>
        </div>
        {* <div class='tvcmsmobile-header-menu-offer-text'>
        </div> *}
        {* <div class="col-sm-6 col-xs-10 tvcmsmobile-cart-acount-text"></div> *}
        {* <div class="tvcmsmobile-header-right">
            <div id='tvcmsmobile-horizontal-menu-left'></div>
        </div> *}
    </div>
    {/strip}
