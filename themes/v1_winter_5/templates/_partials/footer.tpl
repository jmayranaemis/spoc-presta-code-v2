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
    {if isset($page.page_name) && ($page.page_name == 'category' || $page.page_name == 'my-account')}
        {capture assign='spoc_footer_reassurance'}{hook h='displayFooterProduct' mod='blockreassurance'}{/capture}
        {if $spoc_footer_reassurance|trim == ''}
            {capture assign='spoc_footer_reassurance'}{hook h='displayNav1' mod='blockreassurance'}{/capture}
        {/if}

        {capture assign='spoc_footer_newsletter'}{hook h='displayFooterProduct' mod='ps_emailsubscription'}{/capture}
        {if $spoc_footer_newsletter|trim == ''}
            {capture assign='spoc_footer_newsletter'}{hook h='displayNewslettersubscription' mod='ps_emailsubscription'}{/capture}
        {/if}

        {if $spoc_footer_reassurance|trim != '' || $spoc_footer_newsletter|trim != ''}
            <div class="{if $page.page_name == 'category'}spoc-grid-bottom-banners{else}spoc-account-bottom-banners{/if} spoc-footer-banners">
                {if $spoc_footer_reassurance|trim != ''}
                    <div class="{if $page.page_name == 'category'}spoc-grid-reassurance{else}spoc-account-reassurance{/if}">
                        {$spoc_footer_reassurance nofilter}
                    </div>
                {/if}
                {if $spoc_footer_newsletter|trim != ''}
                    <div class="{if $page.page_name == 'category'}spoc-grid-newsletter{else}spoc-account-newsletter{/if}">
                        {$spoc_footer_newsletter nofilter}
                    </div>
                {/if}
            </div>
        {/if}
    {/if}

    {assign var="footer_layout" value="../_partials/{$TVCMSFOOTERCUSTOMLAYOUT}.tpl"}
    {include file="$footer_layout"}     

{/strip}
