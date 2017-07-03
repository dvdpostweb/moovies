$(document).ready(function () {
  
    $('.available-trigger').on('click', function (e) {
        $('.available-versions').toggleClass("on");
        e.preventDefault();
    });

    $('.qualityvod').click(function(e) {
        e.preventDefault();
        $.ajax({
            dataType: 'html',
            url: $(this).attr('href'),
            type: 'GET',
            data: {},
            success: function(data) {
                $('#stream_movie').html(data);
            }

        });
    });

    $('.carousel').carousel({
        pause: true,
        interval: false
    });

    $('.slide-next').click(function (e) {
        var button_switch = $(this).attr('data-switch');
        var button_data = $(this).attr('data-button');
        switch (button_switch) {
            case "audio-button":
                var button_value = $(this).attr('data-button');
                $('.selected-audio').text(button_value);
                $.ajax({
                    dataType: 'html',
                    url: $(this).attr('href'),
                    type: 'GET',
                    data: {},
                    success: function(data) {
                        $('#step_2').html(data);
                    }

                });
                break;
            case "subs-button":
                var button_value2 = $(this).attr('data-button');
                $('.selected-sub').text(button_value2);
                break;
            default :
                alert('Defaut');
                break;
        }
        e.preventDefault();
    });

    $("#chromecasting").click(function (e) {
        e.preventDefault();

        $.ajax({
            method: 'POST',
            url: '/api/v1/orange/callbacks/orangemobile',
            data: {
                'imdb_id': gon.imdb_id
            },
            dataType: 'json',
            success: function (response) {

                var callbackUrl = encodeURIComponent("http://staging.plush.be/api/v1/orange/callbacks/ioscallback?cn="+gon.current_customer.customers_id+"&products_id="+pid+"");
                var audiosubs = encodeURIComponent(response[0]["audsub"]);
                var poster = encodeURIComponent(response[0]["products_image_big"]);
                var title = encodeURIComponent(gon.products_title);

                url = "plush://play?cn="+gon.current_customer.customers_id+"&imdb_id="+product+"&disk_id=0&season_id=0&audiosubs="+audiosubs+"&poster="+poster+"&name="+title+"&callback="+callbackUrl+"";

                window.location = url;

                //console.log(url)

                //$(".qualityvod").last().trigger("click");

                //setTimeout(function() {
                //    jwplayer('player').stop();
                //}, 1000);

            },
            error: function (response) {
                jQuery.facebox("<div class=\"alert alert-danger\">" +
                    "<strong>" + "SYSTEM ERROR!!!" + "</strong>" +
                    "</div>");
            }
        });

        //var userAgent = window.navigator.userAgent;
        //if (userAgent.match(/iPad/i) || userAgent.match(/iPhone/i)) {
        //    url = "plush://play?cn="+gon.current_customer.customers_id+"&imdb_id="+product+"&disk_id=0&season_id=0&callback=http://staging.plush.be/api/v1/orange/callbacks/orangemobile?cn="+gon.current_customer.customers_id+"&products_id="+pid+"";
        //    encodedUrl = encodeURIComponent(url);
        //    window.location = encodedUrl;
        //    console.log(encodedUrl);
        //}
        //$(".qualityvod").last().trigger("click");
        //setTimeout(function() {
        //    jwplayer('player').stop();
        //}, 1000);
    });


});