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
{strip}
{extends file='page.tpl'}

{block name='page_content_container' prepend}
  <section id="content-hook_order_confirmation" class="card spoc-order-confirmation-hero">
    <div class="card-block spoc-confirmation-hero-inner">
      <div class="spoc-confirmation-status">
        <span class="spoc-confirmation-icon" aria-hidden="true">
          <i class="material-icons rtl-no-flip done">&#xE876;</i>
        </span>

        <div class="spoc-confirmation-copy">
          {block name='order_confirmation_header'}
            <p class="spoc-confirmation-eyebrow">{l s='Commande validée' d='Shop.Theme.Checkout'}</p>
            <h1 class="h1 card-title">{l s='Votre commande est confirmée' d='Shop.Theme.Checkout'}</h1>
          {/block}

          <p class="spoc-confirmation-message">
            {if !empty($customer.email)}
              {l s='Un e-mail de confirmation a été envoyé à %email%.' d='Shop.Theme.Checkout' sprintf=['%email%' => $customer.email]}
            {else}
              {l s='Un e-mail de confirmation vient de vous être envoyé avec le récapitulatif et les prochaines étapes.' d='Shop.Theme.Checkout'}
            {/if}
          </p>
        </div>
      </div>

      <div class="spoc-confirmation-actions">
        <a class="spoc-confirmation-btn spoc-confirmation-btn-primary" href="{$urls.pages.index}">
          <i class="material-icons" aria-hidden="true">store</i>
          <span>{l s='Continuer mes achats' d='Shop.Theme.Actions'}</span>
        </a>
        {if !$customer.is_guest && isset($urls.pages.history)}
          <a class="spoc-confirmation-btn spoc-confirmation-btn-secondary" href="{$urls.pages.history}">
            <i class="material-icons" aria-hidden="true">receipt</i>
            <span>{l s='Voir mes commandes' d='Shop.Theme.Customeraccount'}</span>
          </a>
        {/if}
        {if $order.details.invoice_url}
          <a class="spoc-confirmation-link" href="{$order.details.invoice_url}">
            {l s='Télécharger la facture' d='Shop.Theme.Checkout'}
          </a>
        {/if}
      </div>

      <div class="spoc-confirmation-meta" aria-label="{l s='Résumé de la commande' d='Shop.Theme.Checkout'}">
        <div class="spoc-confirmation-meta-item">
          <span class="spoc-confirmation-meta-label">{l s='Référence' d='Shop.Theme.Checkout'}</span>
          <strong>{$order.details.reference}</strong>
        </div>
        <div class="spoc-confirmation-meta-item">
          <span class="spoc-confirmation-meta-label">{l s='Paiement' d='Shop.Theme.Checkout'}</span>
          <strong>{$order.details.payment}</strong>
        </div>
        {if !$order.details.is_virtual}
          <div class="spoc-confirmation-meta-item">
            <span class="spoc-confirmation-meta-label">{l s='Livraison' d='Shop.Theme.Checkout'}</span>
            <strong>{$order.carrier.name}</strong>
          </div>
        {/if}
      </div>

      {block name='hook_order_confirmation'}
        {if !empty($HOOK_ORDER_CONFIRMATION)}
          <div class="spoc-confirmation-hook">
            {$HOOK_ORDER_CONFIRMATION nofilter}
          </div>
        {/if}
      {/block}
    </div>
  </section>
{/block}

{block name='page_content_container'}
  <div class="tvorder-conformation-wrapper spoc-order-confirmation-page">
    <div id="content" class="page-content page-order-confirmation card spoc-order-confirmation-summary">
      <div class="card-block spoc-order-confirmation-summary-inner">
        <div class="row spoc-order-confirmation-grid">

          {block name='order_confirmation_table'}
            {include
              file='checkout/_partials/order-confirmation-table.tpl'
              products=$order.products
              subtotals=$order.subtotals
              totals=$order.totals
              labels=$order.labels
              add_product_link=false
            }
          {/block}

          {block name='order_details'}
            <aside id="order-details" class="col-md-4 spoc-order-details-card">
              <h3 class="h3 card-title">{l s='Détails de la commande' d='Shop.Theme.Checkout'}</h3>
              <ul class="spoc-order-details-list">
                <li>
                  <span>{l s='Référence' d='Shop.Theme.Checkout'}</span>
                  <strong>{$order.details.reference}</strong>
                </li>
                <li>
                  <span>{l s='Moyen de paiement' d='Shop.Theme.Checkout'}</span>
                  <strong>{$order.details.payment}</strong>
                </li>
                {if !$order.details.is_virtual}
                  <li>
                    <span>{l s='Mode de livraison' d='Shop.Theme.Checkout'}</span>
                    <strong>{$order.carrier.name}</strong>
                    <em>{$order.carrier.delay}</em>
                  </li>
                {/if}
              </ul>
            </aside>
          {/block}

        </div>
      </div>
    </div>

    {block name='hook_payment_return'}
      {if ! empty($HOOK_PAYMENT_RETURN)}
      <section id="content-hook_payment_return" class="card definition-list spoc-order-payment-card">
        <div class="card-block spoc-order-payment-inner">
          <div class="row">
            <div class="col-md-12">
              <div class="spoc-order-payment-heading">
                <span class="spoc-order-payment-icon" aria-hidden="true">
                  <i class="material-icons">account_balance</i>
                </span>
                <div>
                  <p>{l s='Prochaine étape' d='Shop.Theme.Checkout'}</p>
                  <h3>{l s='Finaliser le paiement' d='Shop.Theme.Checkout'}</h3>
                </div>
              </div>
              {$HOOK_PAYMENT_RETURN nofilter}
            </div>
          </div>
        </div>
      </section>
      {/if}
    {/block}
  </div>

  {block name='customer_registration_form'}
    {if $customer.is_guest}
      <div id="registration-form" class="card spoc-order-registration-card">
        <div class="card-block">
          <h4 class="h4">{l s='Save time on your next order, sign up now' d='Shop.Theme.Checkout'}</h4>
          {render file='customer/_partials/customer-form.tpl' ui=$register_form}
        </div>
      </div>
    {/if}
  {/block}

  {block name='hook_order_confirmation_1'}
    {hook h='displayOrderConfirmation1'}
  {/block}

  {block name='hook_order_confirmation_2'}
    <div id="content-hook-order-confirmation-footer">
      {hook h='displayOrderConfirmation2'}
    </div>
  {/block}
{/block}
{/strip}
