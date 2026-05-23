<div class="form-group spoc-feature-icon-field" data-spoc-feature-icon-field="1">
  <label class="control-label col-lg-3">
    {l s='Icône de caractéristique' mod='spocfeatureicons'}
  </label>
  <div class="col-lg-9">
    {if $spoc_feature_icon_url}
      <div class="spoc-feature-icon-preview">
        <img src="{$spoc_feature_icon_url|escape:'htmlall':'UTF-8'}" alt="" width="40" height="40">
        <span>{$spoc_feature_icon_filename|escape:'htmlall':'UTF-8'}</span>
      </div>
      <label class="spoc-feature-icon-delete">
        <input type="checkbox" name="spoc_delete_feature_icon" value="1">
        {l s='Supprimer l’icône actuelle' mod='spocfeatureicons'}
      </label>
    {/if}
    <input
      type="file"
      name="spoc_feature_icon"
      accept=".svg,.png,.webp,.jpg,.jpeg,image/svg+xml,image/png,image/webp,image/jpeg"
      class="form-control"
    >
    <p class="help-block">
      {l s='Icône affichée devant cette caractéristique sur les fiches produit. Formats recommandés : SVG ou PNG carré, 512 Ko max.' mod='spocfeatureicons'}
    </p>
  </div>
</div>
<script>
  (function () {
    var field = document.querySelector('input[name="spoc_feature_icon"]');
    if (!field) {
      return;
    }
    var form = field.closest('form');
    if (form) {
      form.setAttribute('enctype', 'multipart/form-data');
    }
  })();
</script>
