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
 * @author    PrestaShop SA <contact@prestashop.com>
 * @copyright 2007-2025 PrestaShop SA
 * @license   https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
 * International Registered Trademark & Property of PrestaShop SA
 *}
{extends file='customer/page.tpl'}

{block name='page_title'}
  {l s='Réinitialisez votre mot de passe' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content_container'}
  <section id="content" class="page-content spoc-auth-content spoc-auth-password-content">

    {block name='page_content_top'}
      {block name='customer_notifications'}
        {include file='_partials/notifications.tpl'}
      {/block}
    {/block}

    <div class="spoc-auth-page spoc-auth-password-page">
      <div class="spoc-auth-shell">

        <section class="spoc-auth-hero">
          <p class="spoc-account-eyebrow">{l s='Espace client' d='Shop.Theme.Customeraccount'}</p>
          <h1>{l s='Réinitialisez votre mot de passe' d='Shop.Theme.Customeraccount'}</h1>
          <p>{l s='Saisissez votre adresse email pour recevoir le lien de réinitialisation.' d='Shop.Theme.Customeraccount'}</p>
        </section>

        <section class="spoc-auth-card">
          <form action="{$urls.pages.password}" class="forgotten-password spoc-auth-form" method="post">

            <ul class="ps-alert-error">
              {foreach $errors as $error}
                <li class="item">
                  <i>
                    <svg viewBox="0 0 24 24">
                      <path fill="#fff" d="M11,15H13V17H11V15M11,7H13V13H11V7M12,2C6.47,2 2,6.5 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4A8,8 0 0,1 20,12A8,8 0 0,1 12,20Z"></path>
                    </svg>
                  </i>
                  <p>{$error}</p>
                </li>
              {/foreach}
            </ul>

            <header>
              <p class="send-renew-password-link">{l s='Please enter the email address you used to register. You will receive a temporary link to reset your password.' d='Shop.Theme.Customeraccount'}</p>
            </header>

            <section class="form-fields">
              <div class="form-group center-email-fields">
                <label class="col-md-2 form-control-label required">{l s='Email address' d='Shop.Forms.Labels'}</label>
                <div class="col-md-5 email">
                  <input type="email" name="email" id="email" placeholder="{l s='Enter address' d='Shop.Forms.Labels'}" value="{if isset($smarty.post.email)}{$smarty.post.email|stripslashes}{/if}" class="form-control" required>
                </div>
                <button class="form-control-submit tvall-inner-btn" name="submit" type="submit">
                  <span>{l s='Send reset link' d='Shop.Theme.Actions'}</span>
                </button>
              </div>
            </section>

          </form>

          <div class="no-account">
            <a href="{$urls.pages.authentication}">
              {l s='Retour à la connexion' d='Shop.Theme.Actions'}
            </a>
          </div>
        </section>

      </div>
    </div>

  </section>
{/block}

{block name='page_footer'}{/block}
