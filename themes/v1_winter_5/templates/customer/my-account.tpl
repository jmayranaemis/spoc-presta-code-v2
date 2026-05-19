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
{extends file='customer/page.tpl'}

{block name='page_title'}
    {l s='Your account' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
    <div class="spoc-account-dashboard spoc-account-child-dashboard">
        {include file='customer/_partials/account-sidebar.tpl' spoc_account_active='my-account'}

        <div class="spoc-account-main">
            <section class="spoc-account-hero spoc-account-page-hero">
                <div>
                    <p class="spoc-account-eyebrow">{l s='Espace client' d='Shop.Theme.Customeraccount'}</p>
                    <h1>
                        {l s='Bonjour' d='Shop.Theme.Customeraccount'}{if !empty($customer.firstname)}, {$customer.firstname|escape:'html':'UTF-8'}{/if}.
                    </h1>
                    <p>
                        {l s='Retrouvez vos commandes, vos adresses, vos informations personnelles et les services liés à votre compte.' d='Shop.Theme.Customeraccount'}
                    </p>
                </div>
            </section>

            <section class="spoc-account-section spoc-account-page-panel">
                <div class="spoc-account-section-heading spoc-account-panel-heading-actions">
                <span class="spoc-account-panel-icon"><i class="material-icons"></i></span>
                 <div>   <h2>{l s='Accès rapides' d='Shop.Theme.Customeraccount'}</h2></div>
                </div>
                <div class="links spoc-account-quick-links">
                    {if !$configuration.is_catalog}
                        <a id="history-link" href="{$urls.pages.history}">
                            <span class="link-item">
                                <i class="material-icons">&#xE916;</i>
                                <span>{l s='Mes commandes' d='Shop.Theme.Customeraccount'}</span>
                            </span>
                        </a>
                    {/if}
                    {if $customer.addresses|count}
                        <a id="addresses-link" href="{$urls.pages.addresses}">
                            <span class="link-item">
                                <i class="material-icons">&#xE56A;</i>
                                <span>{l s='Adresses' d='Shop.Theme.Customeraccount'}</span>
                            </span>
                        </a>
                    {else}
                        <a id="address-link" href="{$urls.pages.address}">
                            <span class="link-item">
                                <i class="material-icons">&#xE567;</i>
                                <span>{l s='Ajouter une adresse' d='Shop.Theme.Customeraccount'}</span>
                            </span>
                        </a>
                    {/if}
                    <a id="identity-link" href="{$urls.pages.identity}">
                        <span class="link-item">
                            <i class="material-icons">&#xE853;</i>
                            <span>{l s='Informations' d='Shop.Theme.Customeraccount'}</span>
                        </span>
                    </a>
                    {if !$configuration.is_catalog}
                        <a id="order-slips-link" href="{$urls.pages.order_slip}">
                            <span class="link-item">
                                <i class="material-icons">&#xE8B0;</i>
                                <span>{l s='Avoirs' d='Shop.Theme.Customeraccount'}</span>
                            </span>
                        </a>
                    {/if}
                    {if $configuration.voucher_enabled && !$configuration.is_catalog}
                        <a id="discounts-link" href="{$urls.pages.discount}">
                            <span class="link-item">
                                <i class="material-icons">&#xE54E;</i>
                                <span>{l s='Bons de réduction' d='Shop.Theme.Customeraccount'}</span>
                            </span>
                        </a>
                    {/if}
                    {if $configuration.return_enabled && !$configuration.is_catalog}
                        <a id="returns-link" href="{$urls.pages.order_follow}">
                            <span class="link-item">
                                <i class="material-icons">&#xE860;</i>
                                <span>{l s='Retours produit' d='Shop.Theme.Customeraccount'}</span>
                            </span>
                        </a>
                    {/if}
                </div>
            </section>

            <section class="spoc-account-section spoc-account-services">
                <div class="spoc-account-section-heading">
                    <h2>{l s='Services associés' d='Shop.Theme.Customeraccount'}</h2>
                </div>
                <div class="links spoc-account-module-links">
                    {block name='display_customer_account'}
                        {hook h='displayCustomerAccount'}
                    {/block}
                </div>
            </section>

            <section class="spoc-account-privacy">
                <i class="material-icons">&#xE88E;</i>
                <p>{l s='Vos informations de compte sont utilisées uniquement pour gérer vos commandes, vos préférences et votre relation avec SPOC.' d='Shop.Theme.Customeraccount'}</p>
            </section>
        </div>
    </div>
{/block}

{block name='page_footer_container'}{/block}
{/strip}
