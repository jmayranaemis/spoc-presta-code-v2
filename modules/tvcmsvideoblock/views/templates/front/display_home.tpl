{**
* 2007-2025 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
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
*  @author    PrestaShop SA <contact@prestashop.com>
*  @copyright 2007-2025 PrestaShop SA
*  @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}
    {strip}
    {if $video_status}
    <div class="container-fluid tvcmsmain-video wow bounceInRight" style="background-image:url({$Videopath}{$video_img})">
        <div class="tvmain-video container">
            <a href="{$video_link}?autoplay=1" class="fancybox fancybox.iframe">
                <div class="tvmain-video-wrapper col-xl-6 col-lg-6 col-md-12 col-sm-12 col-xs-12">
                    <div class="tvmain-video-inner">
                        <div class="tvmain-video-content-box">
                            <div class="tvmain-video-title">{$video_title}</div>
                            <div class="tvmain-video-desc">{$video_desc}</div>
                            <div class="tvmain-video-play">
                                <i class="material-icons">&#xe039;</i>
                            </div>
                            <button>
                                <div class="tvmain-bottom-text tvall-inner-btn">
                                    <span>
                                        <p>{$video_btn_caption}</p>
                                    </span>
                                </div>
                            </button>
                        </div>
                        <div class="tvmain-video-process">
                            <div class="tvmain-video-block-bottom-line-1"></div>
                            <div class="tvmain-video-block-bottom-line-2"></div>
                        </div>
                    </div>
                </div>
            </a>
        </div>
    </div>
    {/if}
    {/strip}