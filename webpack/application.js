$(document).ready(function() {
    $("#green_banner_form").submit(function(event) {
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
});
