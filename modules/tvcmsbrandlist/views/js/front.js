/**
 * SPOC - tvcmsbrandlist
 * 1 item Owl = 1 slide contenant jusqu'à 12 marques
 * affichées en grille 2 lignes x 6 colonnes.
 */

$(document).ready(function () {
    $('.tvcmsbrandlist-slider').each(function () {
        var $section = $(this);
        var $brandSlider = $section.find('.tvbrandlist-slider-content-box');

        if (!$brandSlider.length) {
            return;
        }

        /*
         * Sécurité : Owl met display:none sur .owl-carousel
         * tant qu'il n'est pas initialisé.
         */
        $brandSlider.css('display', 'block');

        /*
         * Si Owl n'est pas disponible, on laisse au moins la grille visible.
         */
        if (typeof $.fn.owlCarousel !== 'function') {
            return;
        }

        /*
         * Si le slider a déjà été initialisé par un autre script,
         * on le détruit proprement avant réinitialisation.
         */
        if ($brandSlider.hasClass('owl-loaded')) {
            $brandSlider.trigger('destroy.owl.carousel');
            $brandSlider.removeClass('owl-loaded owl-drag');
            $brandSlider.find('.owl-stage-outer').children().unwrap();
        }

        /*
         * Nouveau comportement :
         * chaque .spoc-brand-slide contient déjà 12 marques.
         * Donc Owl doit afficher 1 slide à la fois.
         */
        $brandSlider.owlCarousel({
            items: 1,
            margin: 0,
            loop: $brandSlider.children('.spoc-brand-slide').length > 1,
            nav: false,
            dots: false,
            autoplay: false,
            smartSpeed: 500,
            autoHeight: true
        });

        /*
         * Flèches custom du module.
         */
        $section.find('.tvbrandlist-slider-prev')
            .off('click.spocBrand')
            .on('click.spocBrand', function (e) {
                e.preventDefault();
                $brandSlider.trigger('prev.owl.carousel');
            });

        $section.find('.tvbrandlist-slider-next')
            .off('click.spocBrand')
            .on('click.spocBrand', function (e) {
                e.preventDefault();
                $brandSlider.trigger('next.owl.carousel');
            });
    });
});