$(document).ready(function () {

    // full-movie slider
    $('.responsive-carousel').slick({
        dots: false,
        infinite: false,
        draggable: false,
        swipe: false,
        speed: 200,
        slidesToShow: 1,
        slidesToScroll: 1,
        arrows: false,
    });


    $('a.slick-next').click(function (e) {
        $("#steps-wizard").slick('slickNext');
        e.preventDefault();
    });

    $('a.slick-back').click(function (e) {
        $("#steps-wizard").slick('slickPrev');
        e.preventDefault();
    });

    $('a.slick-back-first').click(function (e) {
        $("#steps-wizard").slick( "slickGoTo", 0 );
//            alert('test');
        return false;
    });


    $('.slick-next').click(function (e) {
        var button_switch = $(this).attr('data-switch');
        var button_data = $(this).attr('data-button');
        switch (button_switch) {
            case "audio-button":
                var button_value = $(this).attr('data-button');
                $('.selected-audio').text(button_value);
                //moze ajax dalje.. okinuta vrednost je u promenljivoj button_data
                break;
            case "subs-button":
                var button_value2 = $(this).attr('data-button');
                $('.selected-sub').text(button_value2);
                //moze ajax dalje.. okinuta vrednost je u promenljivoj button_data
                break;
            default :
                alert('Defaut');
                break;
        }
        e.preventDefault();
    });


    //promo code left/filter panel
    $('.available-trigger').on('click', function (e) {
        $('.available-versions').toggleClass("on");
        e.preventDefault();
    });


});
