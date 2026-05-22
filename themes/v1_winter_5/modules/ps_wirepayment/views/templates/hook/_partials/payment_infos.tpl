{**
 * 2007-2026 PrestaShop and Contributors
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License 3.0 (AFL-3.0).
 *}
{strip}
<dl>
  <dt>{l s='Montant à virer' d='Modules.Wirepayment.Shop'}</dt>
  <dd>{$total}</dd>
  <dt>{l s='Bénéficiaire' d='Modules.Wirepayment.Shop'}</dt>
  <dd>{$bankwireOwner}</dd>
  <dt>{l s='Coordonnées bancaires' d='Modules.Wirepayment.Shop'}</dt>
  <dd>{$bankwireDetails nofilter}</dd>
  <dt>{l s='Banque' d='Modules.Wirepayment.Shop'}</dt>
  <dd>{$bankwireAddress nofilter}</dd>
</dl>
{/strip}
