$(document).ready(function () {


    $(window).resize(function () {
        stickyHeaderChart();
    });


    function stickyHeaderChart() {
        var stickyCharterHeader = $('#header-chart');
        var charterHeaderFixPoint = $('.charts-top').outerHeight() + 70;
        var submitFixPoint = $('.planTableOptions').outerHeight() + charterHeaderFixPoint - 70;

        $(window).scroll(function () {
            if ($(window).scrollTop() >= charterHeaderFixPoint) {
                stickyCharterHeader.addClass('affix');
                $('.planTableOptions').addClass('affix');

            }
            if ($(window).scrollTop() < charterHeaderFixPoint) {
                stickyCharterHeader.removeClass('affix');
                $('.planTableOptions').removeClass('affix');
            }
            if ($(window).scrollTop() >= submitFixPoint) {
                stickyCharterHeader.removeClass('affix');
                $('.planTableOptions').removeClass('affix');
            }

        });
    }

    stickyHeaderChart();

    $('.cellContent').on('click', function () {
        var column = parseInt($(this).attr('data-box-order')) + 1;
        $('.cell').removeClass('selected');
        $('.row > .cell:nth-child(' + column + '), .headerRow > .cell:nth-child(' + column + ')').addClass('selected');
        //console.log("clicked");
    });

    $(".film_credits_btn_2").hide();
    $(".film_credits_btn_4").hide();

    $(".2_film_credits").click(function() {
        $(".film_credits_btn_4").hide();
        $(".film_credits_btn_6").hide();
        $(".film_credits_btn_2").show();
    });

    $(".4_film_credits").click(function() {
        $(".film_credits_btn_2").hide();
        $(".film_credits_btn_6").hide();
        $(".film_credits_btn_4").show();
    });

    $(".6_film_credits").click(function() {
        $(".film_credits_btn_2").hide();
        $(".film_credits_btn_4").hide();
        $(".film_credits_btn_6").show();
    });

    if ((window.location.pathname == "/" + gon.locale + "/information/alacarte")) {
        validateActivationCodeFromAlacartePricingPage();
    } else if ((window.location.pathname == "/" + gon.locale + "/informatie/alacarte")) {
        validateActivationCodeFromAlacartePricingPage();
    } else if ((window.location.pathname == "/" + gon.locale + "/information/alacarte")) {
        validateActivationCodeFromAlacartePricingPage();
    }

});


function validateActivationCodeFromAlacartePricingPage() {
    $("#alacarte_activation_code_validation").validate({
        rules: {
            'promotion': {
                required: true
            }
        },
        messages: {
            'promotion': {
                required: required_message_alacarte_promo_code()
            }
        },
        highlight: function(element) {
            $(element).closest('.form-group').addClass('has-error');
        },
        unhighlight: function(element) {
            $(element).closest('.form-group').removeClass('has-error');
        },
        errorElement: 'span',
        errorClass: 'help-block',
        submitHandler: function (form) {
            $.ajax({
                method: 'POST',
                url: '/api/v1/promotion_code_activation',
                data: {
                    'promotion': document.getElementById('promo_code').value
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
        }
    });
}

function required_message_alacarte_promo_code() {
    if (gon.locale == "fr") {
        return "Code promotion est nécessaire."
    } else if (gon.locale == "nl") {
        return "Promotioncode is verplicht."
    } else if (gon.locale == "en") {
        return "Promotion code is required."
    }
}