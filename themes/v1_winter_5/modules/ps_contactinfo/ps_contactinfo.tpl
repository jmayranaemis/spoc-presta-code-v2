{**
 * Custom footer contact block - SPOC Infoline + magasin
 * Theme override: themes/v1_winter_5/modules/ps_contactinfo/ps_contactinfo.tpl
 *}

{assign var='spoc_infoline_title' value='INFOLINE'}
{assign var='spoc_infoline_subtitle' value='Nous vous répondons'}
{assign var='spoc_infoline_days' value='du Lundi au Samedi'}
{assign var='spoc_infoline_hours' value='de 9h à 12h & de 14h à 19h'}

{assign var='spoc_infoline_email_label' value='par mail'}
{assign var='spoc_infoline_email_cta' value='cliquez ici'}
{assign var='spoc_infoline_email' value='support@m2j-exp.fr'}

{assign var='spoc_infoline_phone_label' value='nous téléphoner'}
{assign var='spoc_infoline_phone_display' value='+33(0)4 93 07 40 44'}
{assign var='spoc_infoline_phone_href' value='+33493074044'}

{assign var='spoc_store_title' value='Venez nous voir'}
{assign var='spoc_store_image' value='magasin-spoc.jpg'}
{assign var='spoc_store_address_line_1' value='240 avenue de Verdun'}
{assign var='spoc_store_address_line_2' value='06700 Saint Laurent du Var - France'}
{assign var='spoc_store_map_label' value='Accès au magasin'}
{assign var='spoc_store_map_url' value='https://www.google.com/maps/search/?api=1&query=240%20avenue%20de%20Verdun%2006700%20Saint%20Laurent%20du%20Var%20France'}

<div class="tvfooter-contact-link-wrapper links col-xl-3 col-lg-3 col-md-12 spoc-footer-infoline">
    <div class="spoc-infoline-block">

        <div class="spoc-infoline-header">
            <div class="spoc-infoline-title">
                {$spoc_infoline_title|escape:'html':'UTF-8'}
            </div>
            <div class="spoc-infoline-subtitle">
                {$spoc_infoline_subtitle|escape:'html':'UTF-8'}
            </div>
        </div>

        <div class="spoc-infoline-hours">
            <strong>{$spoc_infoline_days|escape:'html':'UTF-8'}</strong>
            <span>{$spoc_infoline_hours|escape:'html':'UTF-8'}</span>
        </div>

        <div class="spoc-infoline-contact spoc-infoline-mail">
            <div class="spoc-infoline-icon" aria-hidden="true">
                <i class="material-icons">mail_outline</i>
            </div>

            <div class="spoc-infoline-text">
                <span>{$spoc_infoline_email_label|escape:'html':'UTF-8'}</span>
                <a href="mailto:{$spoc_infoline_email|escape:'html':'UTF-8'}"
                   title="Contacter SPOC par mail">
                    {$spoc_infoline_email_cta|escape:'html':'UTF-8'}
                </a>
            </div>
        </div>

        <div class="spoc-infoline-contact spoc-infoline-phone">
            <div class="spoc-infoline-icon" aria-hidden="true">
                <i class="material-icons">phone_iphone</i>
            </div>

            <div class="spoc-infoline-text">
                <span>{$spoc_infoline_phone_label|escape:'html':'UTF-8'}</span>
                <a href="tel:{$spoc_infoline_phone_href|escape:'html':'UTF-8'}"
                   title="Appeler SPOC">
                    {$spoc_infoline_phone_display|escape:'html':'UTF-8'}
                </a>
            </div>
        </div>

        <div class="spoc-store-block">
            <div class="spoc-store-title">
                {$spoc_store_title|escape:'html':'UTF-8'}
            </div>

            <div class="spoc-store-image-wrapper">
                <img
                    src="{$urls.theme_assets}img/{$spoc_store_image|escape:'html':'UTF-8'}"
                    alt="Magasin SPOC Saint Laurent du Var"
                    class="spoc-store-image"
                    loading="lazy"
                    width="300"
                    height="210"
                >
            </div>

            <div class="spoc-store-address">
                <i class="material-icons" aria-hidden="true">location_on</i>
                <div>
                    <span>{$spoc_store_address_line_1|escape:'html':'UTF-8'}</span>
                    <span>{$spoc_store_address_line_2|escape:'html':'UTF-8'}</span>
                </div>
            </div>

            <a
                href="{$spoc_store_map_url|escape:'html':'UTF-8'}"
                class="spoc-store-map-link"
                title="Voir l'accès au magasin SPOC"
                target="_blank"
                rel="noopener noreferrer"
            >
                {$spoc_store_map_label|escape:'html':'UTF-8'}
            </a>
        </div>

    </div>
</div>