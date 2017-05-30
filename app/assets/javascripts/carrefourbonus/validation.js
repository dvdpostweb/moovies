$(document).ready(function () {
    $("#carrefourbonus-btn").click(function () {
        if ($('#carrefour-select-offer-2').is(':checked')) {
            window.location.href = gon.caseCFB2FILMS
        } else if ($('#carrefour-select-offer-4').is(':checked')) {
            window.location.href = gon.caseCFB4FILMS
        } else if ($('#carrefour-select-offer-6').is(':checked')) {
            window.location.href = gon.caseCFB6FILMS
        } else if ($('#carrefour-select-offer-8').is(':checked')) {
            window.location.href = gon.caseCFB8FILMS
        } else if ($('#carrefour-select-offer-10').is(':checked')) {
            window.location.href = gon.caseCFB10FILM
        } else {
            jQuery.facebox("<div class=\"alert alert-danger\">" +
                "<strong>" + gon.home_photobox_error + "</strong>" +
                "</div>");
        }
    });
});