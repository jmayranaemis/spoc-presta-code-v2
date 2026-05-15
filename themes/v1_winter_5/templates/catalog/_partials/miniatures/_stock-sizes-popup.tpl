{if isset($product.spoc_stock_sizes)}
    {assign var=spoc_stock_sizes value=$product.spoc_stock_sizes}
{elseif !isset($spoc_stock_sizes)}
    {assign var=spoc_stock_sizes value=false}
    {if isset($product.id_product) && $product.id_product}
        {assign var=stockInfoModule value=Module::getInstanceByName('tvcmsstockinfo')}
        {if $stockInfoModule}
            {assign var=spoc_stock_sizes value=$stockInfoModule->getProductGridStockSizes($product.id_product)}
        {/if}
    {/if}
{/if}

{if isset($spoc_stock_sizes) && $spoc_stock_sizes && $spoc_stock_sizes|count}
    <div class="spoc-grid-stock-popup" aria-hidden="true">
        <div class="spoc-grid-stock-title">{l s='Tailles disponibles' d='Shop.Theme.Catalog'}</div>
        <ul class="spoc-grid-stock-list">
            {foreach from=$spoc_stock_sizes item=stock_size}
                <li class="spoc-grid-stock-size">{$stock_size.name|escape:'html':'UTF-8'}</li>
            {/foreach}
        </ul>
    </div>
{/if}
