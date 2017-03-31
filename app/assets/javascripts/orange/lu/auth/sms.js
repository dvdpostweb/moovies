$(document).ready(function () {

    if ((window.location.pathname == "/orange/lu/auth/" + gon.locale + "/sms/authorization")) {
        isEligable();
    }

});

function isEligable() {
    $("#is_eligable").validate({
        rules: {
            "phone-number": {
                required: true
            }
        },
        highlight: function(element) {
            $(element).closest('.form-group').addClass('has-error');
        },
        unhighlight: function(element) {
            $(element).closest('.form-group').removeClass('has-error');
        },
        errorElement: 'span',
        errorClass: 'help-block'
    });
}
