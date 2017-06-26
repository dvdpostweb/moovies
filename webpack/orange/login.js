if (localStorage.getItem("plush_phone_number") !== null) {
    $("#sms_number").val(localStorage.getItem("plush_phone_number").substring(4));
}

jQuery.validator.addMethod("phone", function (phone_number, element) {
    phone_number = phone_number.replace(/\s+/g, "");
    return this.optional(element) || phone_number.length > 8 &&
        phone_number.match(/^[0-9-+]+$/);
}, gon.orange_invalid_phone_number_format);

$("#is_eligable").validate({
    rules: {
        "phone-number": {
            required: true,
            phone: true
        }
    },
    messages: {
        "phone-number": {
            required: isEligableValidationMessage()
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
        error.appendTo('#promo-code-error');
    },
    submitHandler: function (form) {
        sms_number = $(".input-group-addon").html() + $.trim($("#sms_number").val());
        $.ajax({
            method: 'POST',
            url: '/orange/lu/api/orange_is_eligable',
            data: {
                'sms_number': sms_number.substring(1),
                'products_id': gon.products_id,
                'code': gon.code
            },
            dataType: 'json',
            success: function (response) {
                if ("True" === response.status) {
                    if (typeof(Storage) !== "undefined") {
                        localStorage.setItem("plush_phone_number", sms_number);
                        $("#is_eligable").hide();
                        $("#orange_purchase").show();
                        jQuery.facebox("<div class=\"alert alert-danger\">" +
                            "<strong>" + response.sms_code + "</strong>" +
                            "</div>");
                    } else {
                        jQuery.facebox("<div class=\"alert alert-danger\">" +
                            "<strong>" + "Sorry! No Web Storage support.." + "</strong>" +
                            "</div>");
                    }
                } else if (0 === response.status) {
                    localStorage.setItem("plush_phone_number", sms_number);
                    jQuery.facebox("<div class=\"alert alert-danger\">" +
                        "<strong>Account with your phone number does not exist !!! Please select your subscription plan</strong>" +
                        "</div>");
                    setTimeout(
                        function () {
                            window.location.href = gon.orange_subscription_action;
                        }, 2000);
                } else if (1 === response.status) {
                    localStorage.setItem("plush_phone_number", sms_number);
                    jQuery.facebox("<div class=\"alert alert-danger\">" +
                        "<strong>Account with your phone number does not exist !!! Please register</strong>" +
                        "</div>");
                    setTimeout(
                        function () {
                            window.location.href = gon.orange_subscription_action + gon.url_code;
                        }, 2000);
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

$("#orange_purchase").validate({
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
            url: '/orange/lu/api/orange_login',
            data: {
                'sms_code': $.trim($("#sms_code").val()),
                'products_id': gon.products_id,
                'plush_phone_number': sms_number.substring(1),
                'code': gon.code
            },
            dataType: 'json',
            success: function (response) {

                if ("True" === response.status) {


                    $.ajax({
                        method: 'POST',
                        url: '/orange/lu/api/automatic_login',
                        data: {
                            'plush_phone_number': sms_number.substring(1),
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
                                "<strong>" + "SYSTEM ERROR!!!" + "</strong>" +
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
                    "<strong>" + "SYSTEM ERROR!!!" + "</strong>" +
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