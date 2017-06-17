$(document).ready(function () {
    step3.urlValidator();
    step3.validateVirmanForm();
    step3.validateBancCard();
    step3.validateOrangeOrangeIsEligable();
    step3.validateOrangeOrangePurchase();

});

var step3 = {
    urlValidator: function () {
        if (window.location.pathname == "/" + gon.locale + "/steps/step3") {
            this.initializeAcordion();
        }
    },
    initializeAcordion: function () {
        $("#accordion").accordion({
            heightStyle: "content"
        });
    },
    validateVirmanForm: function () {
        $("#virman").validate({
            rules: {
                'first_name': {
                    required: true
                },
                'last_name': {
                    required: true
                },
                'telephone': {
                    required: true
                }
            },
            messages: {
                'first_name': {
                    required: this.firstNameValidationMessage()
                },
                'last_name': {
                    required: this.lastNameValidationMessage()
                },
                'last_name': {
                    required: this.telephoneValidationMessage()
                }
            },
            highlight: function (element) {
                $(element).closest('.form-group').addClass('has-error');
            },

            unhighlight: function (element) {
                $(element).closest('.form-group').removeClass('has-error');
            },
            errorElement: 'span',
            errorClass: 'help-block'
        });
    },
    validateOrangeOrangeIsEligable: function () {
        jQuery.validator.addMethod("phone", function (phone_number, element) {
            phone_number = phone_number.replace(/\s+/g, "");
            return this.optional(element) || phone_number.length > 9 &&
                phone_number.match(/^[0-9-+]+$/);
        }, "Invalid phone number");

        $("#is_eligable_subscriber").validate({
            rules: {
                "phone-number": {
                    required: true,
                    phone: true
                }
            },
            messages: {
                "phone-number": {
                    required: this.isEligableValidationMessage()
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
                    url: '/orange/lu/api/orange_is_eligable_step3',
                    data: {
                        'sms_number': $.trim($("#sms_number").val()),
                        'products_id': gon.products_id,
                        'customers_id': gon.current_customer.customers_id
                    },
                    dataType: 'json',
                    success: function (response) {
                        if ("True" === response.status) {
                            if (typeof(Storage) !== "undefined") {
                                localStorage.setItem("plush_phone_number", response.phone_number);
                                $("#is_eligable_subscriber").hide();
                                $("#orange_purchase_subscriber").show();
                                jQuery.facebox("<div class=\"alert alert-danger\">" +
                                    "<strong>" + response.sms_code + "</strong>" +
                                    "</div>");
                            } else {
                                jQuery.facebox("<div class=\"alert alert-danger\">" +
                                    "<strong>" + "Sorry! No Web Storage support.." + "</strong>" +
                                    "</div>");
                            }

                        } else {
                            console.log(response);
                        }
                    }//,
                    //error: function (response) {
                    //    jQuery.facebox("<div class=\"alert alert-danger\">" +
                    //        "<strong>" + "SYSTEM ERROR!!!" + "</strong>" +
                    //        "</div>");
                    //}
                });
            }
        });
    },
    validateOrangeOrangePurchase: function () {
        $("#orange_purchase_subscriber").validate({
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
                    required: this.orangePurchaseMessage(),
                    remote: this.orangePurchaseMessageSmsCodeValidation()
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
                    url: '/orange/lu/api/orange_purchase_step3',
                    data: {
                        'sms_code': $.trim($("#sms_code").val()),
                        'products_id': gon.products_id,
                        'plush_phone_number': localStorage.getItem("plush_phone_number"),
                        'current_customer': gon.current_customer.customers_id
                    },
                    dataType: 'json',
                    success: function (response) {

                        if ("True" === response.status) {
                            window.location.href = gon.step4;
                        } else {
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
    },
    firstNameValidationMessage: function () {
        if (gon.locale == "fr") {
            return "Prénom est nécessaire."
        } else if (gon.locale == "nl") {
            return "Voornaam is verplicht."
        } else if (gon.locale == "en") {
            return "First name is required."
        }
    },
    lastNameValidationMessage: function () {
        if (gon.locale == "fr") {
            return "Nom de famille est nécessaire."
        } else if (gon.locale == "nl") {
            return "Achternaam is verplicht."
        } else if (gon.locale == "en") {
            return "Surname  is required."
        }
    },
    telephoneValidationMessage: function () {
        if (gon.locale == "fr") {
            return "Téléphone est nécessaire."
        } else if (gon.locale == "nl") {
            return "Telefoon is verplicht."
        } else if (gon.locale == "en") {
            return "Telephone is required."
        }
    },
    validateBancCard: function () {
        $("#form_step3").submit(function () {
            if (!$("input[name='brand']").is(":checked")) {
                $("#banc_card_error").empty().html("<div class=\"alert alert-danger\" role=\"alert\">" + gon.banc_card_error_message + "</div>");
                return false;
            }
        });
    },
    isEligableValidationMessage: function () {
        if (gon.locale == "fr") {
            return "Numéro de téléphone est nécessaire."
        } else if (gon.locale == "nl") {
            return "Telefoonnummer is vereist."
        } else if (gon.locale == "en") {
            return "Phone number is required."
        }
    },
    orangePurchaseMessage: function () {
        if (gon.locale == "fr") {
            return "SMS code est nécessaire."
        } else if (gon.locale == "nl") {
            return "SMS code is vereist."
        } else if (gon.locale == "en") {
            return "SMS code is required."
        }
    },
    orangePurchaseMessageSmsCodeValidation: function () {
        if (gon.locale == "fr") {
            return "Le code SMS n'est pas correct."
        } else if (gon.locale == "nl") {
            return "SMS code is niet juist."
        } else if (gon.locale == "en") {
            return "SMS code is not correct."
        }
    }

}
