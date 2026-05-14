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
 * obtain it through the world-wide-web at this URL:
 * https://opensource.org/licenses/AFL-3.0
 *
 * @author    PrestaShop SA <contact@prestashop.com>
 * @copyright 2007-2025 PrestaShop SA
 * @license   https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
 * International Registered Trademark & Property of PrestaShop SA
 *}
{strip}
{if count($groups) > 0}
<div class="product-variants">
  {foreach from=$groups key=id_attribute_group item=group}
    {if !empty($group.attributes)}
    <div class="clearfix product-variants-item">
      <span class="control-label">{$group.name}</span>

      {if $group.group_type == 'select'}
        <select class="form-control form-control-select" id="group_{$id_attribute_group}" data-product-attribute="{$id_attribute_group}" name="group[{$id_attribute_group}]">
          {foreach from=$group.attributes key=id_attribute item=group_attribute}
            {assign var=is_unavailable value=false}
            {if isset($group.attributes_quantity) && isset($group.attributes_quantity[$id_attribute]) && $group.attributes_quantity[$id_attribute] <= 0}
              {assign var=is_unavailable value=true}
            {/if}

            <option value="{$id_attribute}" title="{$group_attribute.name}"{if $group_attribute.selected} selected="selected"{/if}{if $is_unavailable} disabled="disabled"{/if}>
              {$group_attribute.name}
            </option>
          {/foreach}
        </select>

      {elseif $group.group_type == 'color'}
        <ul id="group_{$id_attribute_group}">
          {foreach from=$group.attributes key=id_attribute item=group_attribute}
            {assign var=is_unavailable value=false}
            {if isset($group.attributes_quantity) && isset($group.attributes_quantity[$id_attribute]) && $group.attributes_quantity[$id_attribute] <= 0}
              {assign var=is_unavailable value=true}
            {/if}

            <li class="float-xs-left input-container{if $is_unavailable} disabled unavailable{/if}">
              <label>
                <input class="input-color" type="radio" data-product-attribute="{$id_attribute_group}" name="group[{$id_attribute_group}]" value="{$id_attribute}"{if $group_attribute.selected} checked="checked"{/if}{if $is_unavailable} disabled="disabled" aria-disabled="true"{/if}>
                <span {if $group_attribute.html_color_code}class="color" style="background-color: {$group_attribute.html_color_code}" {/if} {if $group_attribute.texture}class="color texture" style="background-image: url({$group_attribute.texture})" {/if}>
                  <span class="sr-only">{$group_attribute.name}</span>
                  <i class="material-icons rtl-no-flip checkbox-checked">&#xE5CA;</i>
                </span>
              </label>
            </li>
          {/foreach}
        </ul>

      {elseif $group.group_type == 'radio'}
        <ul id="group_{$id_attribute_group}">
          {foreach from=$group.attributes key=id_attribute item=group_attribute}
            {assign var=is_unavailable value=false}
            {if isset($group.attributes_quantity) && isset($group.attributes_quantity[$id_attribute]) && $group.attributes_quantity[$id_attribute] <= 0}
              {assign var=is_unavailable value=true}
            {/if}

            <li class="input-container float-xs-left{if $is_unavailable} disabled unavailable{/if}">
              <label>
                <input class="input-radio" type="radio" data-product-attribute="{$id_attribute_group}" name="group[{$id_attribute_group}]" value="{$id_attribute}"{if $group_attribute.selected} checked="checked"{/if}{if $is_unavailable} disabled="disabled" aria-disabled="true"{/if}>
                <span class="radio-label">{$group_attribute.name}</span>
              </label>
            </li>
          {/foreach}
        </ul>
      {/if}
    </div>
    {/if}
  {/foreach}
</div>
{/if}
{/strip}
