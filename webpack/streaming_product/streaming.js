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
        var userAgent = window.navigator.userAgent;
        //if (userAgent.match(/iPad/i) || userAgent.match(/iPhone/i)) {
            window.location = "plush://cn="+gon.current_customer.customers_id+"&imdb_id="+product+"&disk_id=0&season_id=0&callback=http://staging.plush.be/api/v1/orange/callbacks/orangemobile?cn="+gon.current_customer.customers_id+"&products_id="+pid+";
        //}
        $(".qualityvod").last().trigger("click");
        setTimeout(function() {
            jwplayer('player').stop();
        }, 1000);
    });


});
