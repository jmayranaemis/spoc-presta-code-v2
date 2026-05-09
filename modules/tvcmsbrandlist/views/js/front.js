docker exec -it spoc_build-php-1 sh -lc "cat > /var/www/html/modules/tvcmsbrandlist/views/js/front.js <<'EOF'
/**
 * SPOC - tvcmsbrandlist
 * Carousel marques :
 * 1 item Owl = 1 slide complète contenant 12 marques
 * affichées en grille 2 lignes x 6 colonnes.
 */

$(document).ready(function () {
    var \$brandSlider = $('.tvcmsbrandlist-slider .tvbrandlist-slider-content-box');

    if (!\$brandSlider.length) {
        return;
    }

    /*
     * Sécurité :
     * si Owl a déjà été initialisé par le thème ou par un ancien script,
     * on le détruit proprement avant de le réinitialiser.
     */
    if (\$brandSlider.hasClass('owl-loaded')) {
        \$brandSlider.trigger('destroy.owl.carousel');
        \$brandSlider.removeClass('owl-loaded owl-drag');
        \$brandSlider.find('.owl-stage-outer').children().unwrap();
    }

    /*
     * IMPORTANT :
     * items: 1 car chaque item est maintenant une slide complète
     * contenant 12 marques.
     */
    \$brandSlider.owlCarousel({
        items: 1,
        margin: 0,
        loop: \$brandSlider.children('.spoc-brand-slide').length > 1,
        nav: false,
        dots: false,
        autoplay: false,
        smartSpeed: 500,
        autoHeight: true,
        responsive: {
            0: {
                items: 1
            },
            768: {
                items: 1
            },
            1200: {
                items: 1
            }
        }
    });

    /*
     * Flèches custom du module.
     * On ne déclenche plus .owl-nav .owl-prev / .owl-next
     * car nav:false masque la navigation native Owl.
     */
    $('.tvcmsbrandlist-slider .tvbrandlist-slider-prev')
        .off('click.spocBrand')
        .on('click.spocBrand', function (e) {
            e.preventDefault();
            \$brandSlider.trigger('prev.owl.carousel');
        });

    $('.tvcmsbrandlist-slider .tvbrandlist-slider-next')
        .off('click.spocBrand')
        .on('click.spocBrand', function (e) {
            e.preventDefault();
            \$brandSlider.trigger('next.owl.carousel');
        });
});
EOF"