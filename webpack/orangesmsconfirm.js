$(document).ready(function () {
    jQuery.validator.addMethod("phone", function (phone_number, element) {
        phone_number = phone_number.replace(/\s+/g, "");
        return this.optional(element) || phone_number.length > 8 &&
            phone_number.match(/^[0-9-+]+$/);
    }, gon.orange_invalid_phone_number_format);
    $("#form").validate({
        rules: {
            "promo-code": {
                required: true,
                phone: true
            }
        },
        messages: {
            "promo-code": {
                required: telephoneValidationMessage()
            }
        },
        highlight: function (element) {
            $(element).closest('.form-group').addClass('has-error');
        },
        unhighlight: function (element) {
            $(element).closest('.form-group').removeClass('has-error');
        },
        errorElement: 'span',
        errorClass: 'help-block',
        errorPlacement: function (error, element) {
            error.appendTo('#errordiv');
        },
        submitHandler: function (form) {
            localStorage.setItem("plush_phone_number", $(".input-group-addon").html() + $("#promo-code").val());
            window.location.href = gon.root_localize_path;
        }
    });
});

function telephoneValidationMessage() {
    if (gon.locale == "fr") {
        return "Téléphone est nécessaire."
    } else if (gon.locale == "nl") {
        return "Telefoon is verplicht."
    } else if (gon.locale == "en") {
        return "Telephone is required."
    }
}