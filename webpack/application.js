$(document).ready(function () {
    $("#green_banner_form").submit(function (event) {
        event.preventDefault();
        $.ajax({
            method: 'POST',
            url: '/api/v1/promotion_code_activation',
            data: {
                'promotion': $("#promotion").val()
            },
            dataType: 'json',
            success: function (response) {
                if (1 === response.status) {
                    jQuery.facebox("<div class=\"alert alert-danger\">" +
                        "<strong>" + response.message + "</strong>" +
                        "</div>");
                } else if (2 === response.status) {
                    window.location.href = response.message;
                }
            }
        });
    });
    $("#load_more").click(function(e) {
        e.preventDefault();
        $.ajax({
            url: $('.next_page:last').attr('href'),
            dataType: 'script'
        });
    });
});

jQuery.fn.extend({
    toggleText: function (a, b) {
        var isClicked = false;
        var that = this;
        this.click(function () {
            if (isClicked) {
                that.html(a);
                isClicked = false;
            }
            else {
                that.html(b);
                isClicked = true;
            }
        });
        return this;
    }
});


$(document).ready(function () {
    "use strict"; // Start of use strict

    function mainSidemenuState(state) {
        switch (state) {
            case 'on':
                $(".canavas").addClass('on');
                $("#overlay").addClass('on');
                break;
            case 'off':
                $(".canavas").removeClass('on');
                $("#overlay").removeClass('on');
                break;
        }
    }

    function filtersPanelState(state) {
        $('.content-left #filters-open-adaptive .fa').toggleClass("fa-arrow-up fa-arrow-down");
        switch (state) {
            case 'on':
                $('#filters-open-adaptive').addClass('on');
                $('.content-left').addClass('on');
                $("#overlay").addClass('on');
                break;
            case 'off':
                $('#filters-open-adaptive').removeClass('on');
                $('.content-left').removeClass('on');
                $("#overlay").removeClass('on');
                break;
        }
    }

    $('.canavas').waitForImages(function () {
        $('.canavas').fadeIn('1000');
    });

    $(".side-menu-close").on('click', function () {
        mainSidemenuState('off');
    });

    $(".navbar-toggle").on('click', function () {
        mainSidemenuState('on');
    });

    $(window).resize(function () {
        //checkMq();
        //mainSidemenuState('off');
        //filtersPanelState('off');
    });

    $('.navbar-default').affix({
        offset: {
            top: 80
        }
    });

    $('#on-top').affix({
        offset: {
            top: 380
        }
    });

    $('#on-top').on('click', function (event) {
        $(this).removeClass('affix');
        $('html, body').animate({scrollTop: 0}, '500');
    });

    $(".top-header > div").clone().appendTo(".side-menu-login");
    $(".navbar-collapse").clone().appendTo(".side-menu-nav");
    $(".top-search-holder").clone().appendTo(".side-menu-search");

    $('#user-status-switch').on('click', function () {
        $('.panel-enter-code, .top-green-status').toggleClass('on');
        return false;
    }).toggleText('<i class="fa fa-copy marr5"></i><a href="#" id="promo-code-open" class="no-decoration">(voir tout)</a>', '<i class="fa fa-minus marr5"></i><a href="#" id="promo-code-open" class="no-decoration"> (minimiser)</a>');


    $('#left-promo-code-trigger').on('click', function (e) {
        $('.left-promo-code').toggleClass("on");
        $('#left-promo-code-trigger .fa-caret-down').toggleClass("white");
        e.preventDefault();
    });

    $('#filters-open-adaptive').on('click', function () {
        $(this).toggleClass("green");
        if ($('.content-left').is(".on")) {
            filtersPanelState('off');
        } else {
            filtersPanelState('on');
            $(".canavas").removeClass('on');
        }
    });

    $('.chosen-select').chosen({allow_single_deselect: false});

});
