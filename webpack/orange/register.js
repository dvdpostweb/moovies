if (localStorage.getItem("plush_phone_number") !== null) {
    if (gon.request_host === "staging.plush.be" || gon.request_host === "plush.be") {
        $("#sms_number").val(localStorage.getItem("plush_phone_number").substring(3));
    } else {
        $("#sms_number_register").val(localStorage.getItem("plush_phone_number").slice(4));
    }
}
jQuery.validator.addMethod("phone", function (phone_number, element) {
    phone_number = phone_number.replace(/\s+/g, "");
    return this.optional(element) || phone_number.length > 8 &&
        phone_number.match(/^[0-9-+]+$/);
}, gon.orange_invalid_phone_number_format);

$("#is_eligable_registration").validate({
    rules: {
        "phone_number": {
            required: true,
            phone: true,
            remote: "/api/v1/check_presence_of_customer_telephone_number_orange_registration"
        }
    },
    messages: {
        "phone_number": {
            required: isEligableValidationMessage(),
            remote: function() {

                if (gon.locale == "fr") {

                    return "Ce numéro de téléphone est déjà enregistré dans le système."

                } else if (gon.locale == "nl") {

                    return "Alles wat je nodig hebt, is een perfecte manier om je te helpen."

                } else if (gon.locale == "en") {

                    return "This phone number is already registered in the system.";

                }
            }
        }
    },
    highlight: function (element) {
        $(element).closest('.form-group').addClass('has-error');
    },
    unhighlight: function (element) {
        $(element).closest('.form-group').removeClass('has-error');
    },
    errorPlacement: function (error, element) {
        error.appendTo('#promo-code-error');
    },
    errorElement: 'span',
    errorClass: 'help-block',
    submitHandler: function (form) {
        sms_number = $(".input-group-addon").html() + $.trim($("#sms_number_register").val());
        $.ajax({
            method: 'POST',
            url: '/orange/lu/api/orange_register',
            data: {
                'sms_number': sms_number.slice(1),
                'products_id': gon.products_id,
                'code': gon.code,
                'orange_luxembourg_promo_code': gon.orange_luxembourg_promo_code
            },
            dataType: 'json',
            success: function (response) {
                if ("True" === response.status) {
                    if (typeof(Storage) !== "undefined") {
                        localStorage.setItem("plush_phone_number", $(".input-group-addon").html() + $.trim($("#sms_number_register").val()));
                        $("#is_eligable_registration").hide();
                        $("#orange_purchase_register").show();
                        jQuery.facebox("<div class=\"alert alert-danger\">" +
                            "<strong>" + response.sms_code + "</strong>" +
                            "</div>");
                    } else {
                        jQuery.facebox("<div class=\"alert alert-danger\">" +
                            "<strong>" + "Sorry! No Web Storage support.." + "</strong>" +
                            "</div>");
                    }
                } else {
                    jQuery.facebox("<div class=\"alert alert-danger\">" +
                        "<strong>" + response.status + "</strong>" +
                        "</div>");
                }
            },
            error: function (response) {
                jQuery.facebox("<div class=\"alert alert-danger\">" +
                    "<strong>" + "SYSTEM ERROR!!!" + "</strong>" +
                    "</div>");
            }
        });
    }
});

$("#orange_purchase_register").validate({
    rules: {
        "sms-code": {
            required: true,
            remote: {
                url: "/orange/lu/api/check_sms_activation_code"
            }
        }
    },
    messages: {
        "sms-code": {
            required: orangePurchaseMessage(),
            remote: orangePurchaseMessageSmsCodeValidation()
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
    submitHandler: function (form) {
        sms_number = localStorage.getItem("plush_phone_number");
        $.ajax({
            method: 'POST',
            url: '/orange/lu/api/orange_purchase',
            data: {
                'sms_code': $.trim($("#sms_code").val()),
                'products_id': gon.products_id,
                'plush_phone_number': sms_number.slice(1),
                'code': gon.code,
                'orange_luxembourg_promo_code': gon.orange_luxembourg_promo_code
            },
            dataType: 'json',
            success: function (response) {

                if ("TRUE" === response.status) {


                    $.ajax({
                        method: 'POST',
                        url: '/orange/lu/api/automatic_register',
                        data: {
                            'plush_phone_number': sms_number.slice(1),
                            'products_id': gon.products_id,
                        },
                        dataType: 'json',
                        success: function (response) {
                            if (0 === response.status) {
                                window.location.href = response.redirect_path
                            }
                        },
                        error: function (response) {
                            jQuery.facebox("<div class=\"alert alert-danger\">" +
                                "<strong>" + response.status + "</strong>" +
                                "</div>");
                        }
                    });


                } else {
                    jQuery.facebox("<div class=\"alert alert-danger\">" +
                        "<strong>" + response.status + "</strong>" +
                        "</div>");
                }

            },
            error: function (response) {
                jQuery.facebox("<div class=\"alert alert-danger\">" +
                    "<strong>" + response.status + "</strong>" +
                    "</div>");
            }
        });
    }
});

function isEligableValidationMessage() {
    if (gon.locale == "fr") {
        "Numéro de téléphone est nécessaire.";
    } else if (gon.locale == "nl") {
        "Telefoonnummer is vereist.";
    } else if (gon.locale == "en") {
        "Phone number is required.";
    }
}

function orangePurchaseMessage() {
    if (gon.locale == "fr") {
        "SMS code est nécessaire."
    } else if (gon.locale == "nl") {
        "SMS code is vereist."
    } else if (gon.locale == "en") {
        "SMS code is required."
    }
}

function orangePurchaseMessageSmsCodeValidation() {
    if (gon.locale == "fr") {
        "Le code SMS n'est pas correct."
    } else if (gon.locale == "nl") {
        "SMS code is niet juist."
    } else if (gon.locale == "en") {
        "SMS code is not correct."
    }
}