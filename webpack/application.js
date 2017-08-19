$('a[rel*=facebox]').facebox();

//window.onload = function () {

//    if (typeof(Storage) !== "undefined") {
//        if (gon && gon.current_customer === null && localStorage.getItem("plush_phone_number") !== null) {
//            $.ajax({
//                method: 'POST',
//                url: '/orange/lu/auth/orange_sms_auto_login',
//                data: {
//                    'plush_phone_number': localStorage.getItem("plush_phone_number")
//                },
//                dataType: 'json',
//                success: function (response) {
//                    if (0 === response.status) {
                        //$(".login-holder").empty();
                        //if (gon && gon.locale === "fr") {
                        //    autoLoginMenuFR = "<li>" +
                        //        "<a href=\"/fr/mon-compte/sign_out\" data-method=\"delete\" id=\"logout\" rel=\"nofollow\">Déconnexion</a> <span>(4dae@plush.temp)</span>" +
                        //        "</li>" +
                        //        "<li>" +
                        //        "<a href='fr/mon-compte/' + response.current_customer_id + '>Mon compte</a>" +
                        //        "</li>";
                        //    $(".login-holder").html(autoLoginMenuFR);
                        //} else if (gon && gon.locale === "nl") {
                        //    autoLoginMenuNL = "<li>" +
                        //        "<a href=\"/nl/mijn-account/sign_out\" data-method=\"delete\" id=\"logout\" rel=\"nofollow\">Uitloggen</a> <span>(4dae@plush.temp)</span>" +
                        //        "</li>" +
                        //        "<li>" +
                        //        "<a href='/nl/mijn-account/' + response.current_customer_id + '>Mijn account</a>" +
                        //        "</li>";
                        //    $(".login-holder").html(autoLoginMenuNL);
                        //} else if (gon && gon.locale === "en") {
                        //    autoLoginMenuEN = "<li>" +
                        //        "<a href=\"/en/my-account/sign_out\" data-method=\"delete\" id=\"logout\" rel=\"nofollow\">Log out</a> <span>(4dae@plush.temp)</span>" +
                        //        "</li>" +
                        //        "<li>" +
                        //        "<a href='/en/my-account/' + response.current_customer_id + '>My account</a>" +
                        //        "</li>";
                        //    $(".login-holder").html(autoLoginMenuEN);
                        //}
                        //window.location.reload()
//                    }
//                },
//                error: function (response) {
//                    console.log('ORANGE AUTO LOGIN SYSTEM ERROR!!!');
//                }
//            });
//        }
//    } else {
//        console.log("Sorry! No Web Storage support..");
//    }
//};

if (gon && gon.mobile === "MOBILE") {
    var w = $(window), d = $(document);
    w.scroll(function () {
        if (w.scrollTop() + w.height() == d.height()) {
            $.ajax({url: $('.next_page').last().attr('href'), dataType: 'script'});
        }
    });
}

$("[id=pagination]").hide();


$("#wha_ppv").submit(function (event) {
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

$("#left_sidebar_promotion_form").submit(function (event) {

    //if (gon.development === true || gon.staging === true) {
    //
    //    console.log("OMG! Check this window out!");
    //
    //}


    event.preventDefault();
    $.ajax({
        method: 'POST',
        url: '/api/v1/promotion_code_activation',
        data: {
            'promotion': $("#promotion_code_ls").val()
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

$("#load_more").click(function (e) {
    e.preventDefault();
    $.ajax({
        url: $('.next_page:last').attr('href'),
        dataType: 'script'
    });
});
$(document).ready(function () {
    $(".dropdown-toggle").dropdown();
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
}).toggleText('<i class="fa fa-copy marr5"></i><a href="#" id="promo-code-open" class="no-decoration">('+ gon.open_banner +')</a>', '<i class="fa fa-minus marr5"></i><a href="#" id="promo-code-open" class="no-decoration"> ('+ gon.close_banner  +')</a>');


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

var originalLeave = $.fn.popover.Constructor.prototype.leave;
$.fn.popover.Constructor.prototype.leave = function (obj) {
    var self = obj instanceof this.constructor ? obj : $(obj.currentTarget)[this.type](this.getDelegateOptions()).data('bs.' + this.type);
    originalLeave.call(this, obj);

    if (obj.currentTarget) {
        self.$tip.one('mouseenter', function () {
            clearTimeout(self.timeout);
            self.$tip.one('mouseleave', function () {
                $.fn.popover.Constructor.prototype.leave.call(self, self);
            });
        })
    }
};

function popoverTrig() {
    $('.popper').popover({
        placement: "left",
        trigger: "hover",
        container: 'body',
        html: true,
        delay: {
            show: 300,
            hide: 100
        },
        content: function () {
            return $(this).next('.synopsys-content').html();
        }
    })
};

// home slider
$('.responsive-carousel').slick({
    dots: false,
    infinite: false,
    speed: 200,
    slidesToShow: 4,
    slidesToScroll: 2,
    responsive: [
        {
            breakpoint: 980,
            settings: {
                slidesToShow: 3,
                slidesToScroll: 2,
            }
        },
        {
            breakpoint: 600,
            settings: {
                slidesToShow: 2,
                slidesToScroll: 1
            }
        }
    ]
});

//raty stars
$('.slide-score').raty({
    readOnly: true,
    score: function () {
        return $(this).attr('data-score');
    }
});

// synopsis adaptive trigg open
$('.synopsys-adaptive-open').on('click', function () {
    $('.synopsys-adaptive-open').removeClass('hidden');
    $(this).addClass('hidden');
    $('.synopsys-content').removeClass('on');
    $(this).prev('.synopsys-content').addClass('on');
    return false;
})

// synopsis adaptive trigg close
$('.synopsys-adaptive-close').on('click', function () {
    $(this).closest('.slick-slide').children('.synopsys-adaptive-open').removeClass('hidden');
    $(this).closest('.grid-slide').children('.synopsys-adaptive-open').removeClass('hidden');
    $(this).closest('.synopsys-content').removeClass('on');

    return false;
})

// modernizr
function checkModernizr() {
    if (Modernizr.mq('(min-width: 981px)')) {
        popoverTrig();
        fancyboxBinder();
    }
    if (Modernizr.mq('(max-width: 980px)')) {
        $('.popper').popover('destroy');
        fancyboxUnBinder();
    }
}

// the call to checkMq here will execute after the document has loaded
checkModernizr();

$(window).resize(function () {
    checkModernizr();
});

$('.tags-autocomplete-holder li.ui-menu-item').on('click', function (e) {
    e.preventDefault();
});

function fancyboxBinder() {
    $(".fancybox").unbind('click')
    $("a.fancybox").fancybox({
        padding: 5,
        helpers: {
            overlay: {
                locked: false,
                overlayShow: true
            }
        },
    })
}

function fancyboxUnBinder() {
    $.fancybox.close();
    $(".fancybox").bind('click', function (e) {
        e.preventDefault();
    })
    $(document).unbind('click.fb-start');
}

$(".icheckbox,.iradio").iCheck({
    checkboxClass: 'icheckbox_minimal-grey',
    radioClass: 'iradio_minimal-grey'
});