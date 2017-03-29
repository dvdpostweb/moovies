$(document).ready(function () {
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
            'activation_promo_code_alacarte': {
                required: true,
                remote: "/api/v1/check_activation_code_validity"
            }
        },
        highlight: function(element) {
            $(element).closest('.form-group').addClass('has-error');
        },
        unhighlight: function(element) {
            $(element).closest('.form-group').removeClass('has-error');
        },
        errorElement: 'span',
        errorClass: 'help-block'//,
    });
}