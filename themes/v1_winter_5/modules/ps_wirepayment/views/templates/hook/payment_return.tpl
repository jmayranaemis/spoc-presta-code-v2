{**
 * 2007-2026 PrestaShop and Contributors
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License 3.0 (AFL-3.0).
 *}
{strip}
<p>
  {l s='Votre commande est bien enregistrée.' d='Modules.Wirepayment.Shop'}<br>
  {l s='Pour finaliser votre achat, effectuez le virement bancaire avec les informations ci-dessous.' d='Modules.Wirepayment.Shop'}
</p>

{include file='module:ps_wirepayment/views/templates/hook/_partials/payment_infos.tpl'}

<p>
  {l s='Indiquez la référence %s dans le libellé du virement afin que nous puissions rapprocher votre paiement rapidement.' sprintf=[$reference] d='Modules.Wirepayment.Shop'}<br>
  {l s='Ces informations vous ont également été envoyées par e-mail.' d='Modules.Wirepayment.Shop'}
</p>

<strong>{l s='Votre commande sera préparée dès réception du virement.' d='Modules.Wirepayment.Shop'}</strong>

<p>
  {l
    s='Besoin d’aide ? Contactez [1]notre service client[/1].'
    d='Modules.Wirepayment.Shop'
    sprintf=[
      '[1]' => "<a href='{$contact_url}'>",
      '[/1]' => '</a>'
    ]
  }
</p>
{/strip}
