$("#orange_stop").click(function(e) {
    e.preventDefault();

    $.ajax({
        method: 'POST',
        url: '/orange/lu/api/orange_stop',
        data: {
            'current_customer': gon.current_customer.customers_id
        },
        dataType: 'json',
        success: function (response) {

            jQuery.facebox("<div class=\"alert alert-danger\">" +
                "<strong>" + response.msg + "</strong>" +
                "</div>");

        },
        error: function (response) {
            console.log('CHECKED AJAX ERROR!!!');
        }
    });

});

$("#orange_password").click(function(e) {
    e.preventDefault();

    $.ajax({
        method: 'POST',
        url: '/orange/lu/api/orange_password',
        data: {
            'current_customer': gon.current_customer.customers_id
        },
        dataType: 'json',
        success: function (response) {

            jQuery.facebox("<div class=\"alert alert-danger\">" +
                "<strong>" + response.msg + "</strong>" +
                "</div>");

        },
        error: function (response) {
            console.log('CHECKED AJAX ERROR!!!');
        }
    });

});
