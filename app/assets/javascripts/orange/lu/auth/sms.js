$(document).ready(function () {

        eligibilityServiceOnlyLogin();
        eligibilityServiceOnlyRegister()
        orangePurchase();

});

function eligibilityServiceOnlyLogin() {

    jQuery.validator.addMethod("phone", function (phone_number, element) {
        phone_number = phone_number.replace(/\s+/g, "");
        return this.optional(element) || phone_number.length > 9 &&
            phone_number.match(/^[0-9-+]+$/);
    }, "Invalid phone number");

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
        submitHandler: function (form) {
            $.ajax({
                method: 'POST',
                url: '/orange/lu/api/orange_is_eligable',
                data: {
                    'sms_number': $.trim($("#sms_number").val()),
                    'products_id': gon.products_id
                },
                dataType: 'json',
                success: function (response) {
                  if (0 === response.status) {
                    jQuery.facebox("<div class=\"alert alert-danger\">" +
                        "<strong>Account with your phone number does not exist !!! You will be redirected to the Orange registration page for 5 seconds</strong>" +
                        "</div>");
                        setTimeout(
                          function() {
                            window.location.href = "/orange/lu/auth/" + gon.locale + "/sms/registration?phone_number=" + $.trim($("#sms_number").val()) + ""
                          }, 5000);

                  } else if ("True" === response.status) {
                    if (typeof(Storage) !== "undefined") {
                      localStorage.setItem("plush_phone_number", response.phone_number);
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
}

function eligibilityServiceOnlyRegister() {
  $("#sms_number").val(gon.phone_number);
    jQuery.validator.addMethod("phone", function (phone_number, element) {
        phone_number = phone_number.replace(/\s+/g, "");
        return this.optional(element) || phone_number.length > 9 &&
            phone_number.match(/^[0-9-+]+$/);
    }, "Invalid phone number");

    $("#is_eligable_registration").validate({
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
        submitHandler: function (form) {
            $.ajax({
                method: 'POST',
                url: '/orange/lu/api/orange_register',
                data: {
                    'sms_number': $.trim($("#sms_number").val()),
                    'products_id': gon.products_id
                },
                dataType: 'json',
                success: function (response) {
                    if ("True" === response.status) {
                        if (typeof(Storage) !== "undefined") {
                            localStorage.setItem("plush_phone_number", response.phone_number);
                            $("#is_eligable_registration").hide();
                            $("#orange_purchase").show();
                            jQuery.facebox("<div class=\"alert alert-danger\">" +
                                "<strong>" + response.sms_code + "</strong>" +
                                "</div>");
                        } else {
                            jQuery.facebox("<div class=\"alert alert-danger\">" +
                                "<strong>" + "Sorry! No Web Storage support.." + "</strong>" +
                                "</div>");
                        }
                    } else if ("Subscriber is not eligible for the service" === response.status) {
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
}

function orangePurchase() {

    $("#orange_purchase").validate({
        rules: {
            "sms-code": {
                required: true,
                remote: {
                    url:"/orange/lu/api/check_sms_activation_code"
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
            $.ajax({
                method: 'POST',
                url: '/orange/lu/api/orange_purchase',
                data: {
                    'sms_code': $.trim($("#sms_code").val()),
                    'products_id': gon.products_id,
                    'plush_phone_number': localStorage.getItem("plush_phone_number"),
                    'code': gon.code
                },
                dataType: 'json',
                success: function (response) {

                    if ("True" === response.status) {


                        $.ajax({
                            method: 'POST',
                            url: '/orange/lu/api/automatic_login',
                            data: {
                                'plush_phone_number': localStorage.getItem("plush_phone_number"),
                                'products_id': gon.products_id,
                            },
                            dataType: 'json',
                            success: function (response) {
                                if (0 === response.status) {
                                    window.location.href = response.redirect_path
                                }
                            },
                            error: function (response) {
                                console.log('CHECKED AJAX ERROR!!!');
                            }
                        });


                    } else if ("Subscriber is not eligible for the service" === response.status) {
                        jQuery.facebox("<div class=\"alert alert-danger\">" +
                            "<strong>" + response.status + "</strong>" +
                            "</div>");
                    }

                },
                error: function (response) {
                    console.log('CHECKED AJAX ERROR!!!');
                }
            });
        }
    });

}

function isEligableValidationMessage() {
    if (gon.locale == "fr") {
        return "Numéro de téléphone est nécessaire."
    } else if (gon.locale == "nl") {
        return "Telefoonnummer is vereist."
    } else if (gon.locale == "en") {
        return "Phone number is required."
    }
}

function orangePurchaseMessage() {
    if (gon.locale == "fr") {
        return "SMS code est nécessaire."
    } else if (gon.locale == "nl") {
        return "SMS code is vereist."
    } else if (gon.locale == "en") {
        return "SMS code is required."
    }
}

function orangePurchaseMessageSmsCodeValidation() {
    if (gon.locale == "fr") {
        return "Le code SMS n'est pas correct."
    } else if (gon.locale == "nl") {
        return "SMS code is niet juist."
    } else if (gon.locale == "en") {
        return "SMS code is not correct."
    }
}
