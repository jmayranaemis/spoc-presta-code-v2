{**
 * 2007-2025 PrestaShop
 *
 * Login page customized for SPOC theme.
 * This template owns the authentication page layout.
 * Do not style this page from customer/page.tpl.
 *}

{extends file='customer/page.tpl'}

{block name='page_title'}
  {l s='Connectez-vous à votre compte' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content_container'}
  <section id="content" class="page-content spoc-auth-content">

    {block name='page_content_top'}
      {block name='customer_notifications'}
        {include file='_partials/notifications.tpl'}
      {/block}
    {/block}

    <div class="spoc-auth-page">
      <div class="spoc-auth-shell">

        <section class="spoc-auth-hero">
          <p class="spoc-account-eyebrow">{l s='Espace client' d='Shop.Theme.Customeraccount'}</p>
          <h1>{l s='Connectez-vous à votre compte' d='Shop.Theme.Customeraccount'}</h1>
          <p>{l s='Accédez à votre espace client pour suivre vos commandes, gérer vos informations et retrouver vos services.' d='Shop.Theme.Customeraccount'}</p>
        </section>

        <section class="spoc-auth-card">
          {block name='login_form_container'}
            <div class="login-form">
              {render file='customer/_partials/login-form.tpl' ui=$login_form}
            </div>

            {block name='display_after_login_form'}
              {hook h='displayCustomerLoginFormAfter'}
            {/block}

            <div class="no-account">
              <a href="{$urls.pages.register}" data-link-action="display-register-form">
                {l s='Pas de compte ? Créez-en un' d='Shop.Theme.Customeraccount'}
              </a>
            </div>
          {/block}
        </section>

      </div>
    </div>

  </section>
{/block}

{block name='page_footer'}{/block}