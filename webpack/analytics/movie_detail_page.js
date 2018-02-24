$.get("https://api.teletext.io/api/v1/geo-ip", function(response) {
    ahoy.track("Viewed Movie Detail Page", {
        products_id: gon.products_id,
        country_name: response.name
    });
    $.ajax({
        method: 'POST',
        url: '/api/v1/save_country_for_movie',
        data: {
            'country': response.name
        },
        dataType: 'json'//,
        //success: function (response) {
        //    console.log(response)
        //}
    });
});