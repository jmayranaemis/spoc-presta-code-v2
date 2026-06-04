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
{extends file='customer/page.tpl'}

{block name='page_title'}
    {l s='Créez votre compte' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content_container'}
    <section id="content" class="page-content spoc-auth-content spoc-auth-register-content">

        {block name='page_content_top'}
            {block name='customer_notifications'}
                {include file='_partials/notifications.tpl'}
            {/block}
        {/block}

        <div class="spoc-auth-page spoc-auth-register-page">
            <div class="spoc-auth-shell">

                <section class="spoc-auth-hero">
                    <p class="spoc-account-eyebrow">{l s='Espace client' d='Shop.Theme.Customeraccount'}</p>
                    <h1>{l s='Créez votre compte' d='Shop.Theme.Customeraccount'}</h1>
                    <p>{l s='Renseignez vos informations pour finaliser vos commandes plus rapidement et retrouver votre suivi client.' d='Shop.Theme.Customeraccount'}</p>
                </section>

                <section class="spoc-auth-card">
                    {block name='register_form_container'}
                        {$hook_create_account_top nofilter}
                        <section class="register-form spoc-auth-form">
                            {render file='customer/_partials/customer-form.tpl' ui=$register_form}
                        </section>

                        <div class="no-account">
                            <a href="{$urls.pages.authentication}">
                                {l s='Déjà un compte ? Connectez-vous' d='Shop.Theme.Customeraccount'}
                            </a>
                        </div>
                    {/block}
                </section>

            </div>
        </div>

    </section>
{/block}

{block name='page_footer'}{/block}
