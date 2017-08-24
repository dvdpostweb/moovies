$(document).ready(function () {
    step3.urlValidator();
    step3.validateVirmanForm();
    step3.validateBancCard();
    step3.validateOrangeOrangeIsEligable();
    step3.validateOrangeOrangePurchase();
    step3.convertToCustomer();

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
            return this.optional(element) || phone_number.length > 8 &&
                phone_number.match(/^[0-9-+]+$/);
        }, gon.orange_invalid_phone_number_format);

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
                sms_number = $(".input-group-addon").html() + $.trim($("#sms_number").val());
                $.ajax({
                    method: 'POST',
                    url: '/orange/lu/api/orange_is_eligable_step3',
                    data: {
                        'sms_number': sms_number.slice(1),
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
                                if (gon && gon.development === true) {
                                    jQuery.facebox("<div class=\"alert alert-danger\">" +
                                        "<strong>" + response.sms_code + "</strong>" +
                                        "</div>");
                                }
                            } else {
                                jQuery.facebox("<div class=\"alert alert-danger\">" +
                                    "<strong>" + "Sorry! No Web Storage support.." + "</strong>" +
                                    "</div>");
                            }

                        } else {
                            jQuery.facebox("<div class=\"alert alert-danger\">" +
                                "<strong>" + response.status + "</strong>" +
                                "</div>")
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
    },
    validateOrangeOrangePurchase: function () {
        $("#orange_purchase_subscriber").validate({
            rules: {
                "sms-code": {
                    required: true//,
                    //remote: {
                    //    url: "/api/v1/check_sms_activation_code"
                    //}
                }
            },
            messages: {
                "sms-code": {
                    required: this.orangePurchaseMessage()//,
                    //remote: this.orangePurchaseMessageSmsCodeValidation()
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
                        jQuery.facebox("<div class=\"alert alert-danger\">" +
                            "<strong>" + "SYSTEM ERROR!!!" + "</strong>" +
                            "</div>");
                    }
                });
            }
        });
    },
    convertToCustomer: function() {
        $("#convert_to_customer").click(function(e) {
            e.preventDefault();


            $.ajax({
                method: 'POST',
                url: '/orange/lu/api/convert_to_customer',
                data: {
                    'current_customer': gon.current_customer.customers_id
                },
                dataType: 'json',
                success: function (response) {

                    if ("TRUE" === response.status) {
                        window.location.href = response.root;
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


        });
    },
    firstNameValidationMessage: function () {
        if (gon.locale == "fr") {
            "Prénom est nécessaire."
        } else if (gon.locale == "nl") {
            "Voornaam is verplicht."
        } else if (gon.locale == "en") {
            "First name is required."
        }
    },
    lastNameValidationMessage: function () {
        if (gon.locale == "fr") {
            "Nom de famille est nécessaire."
        } else if (gon.locale == "nl") {
            "Achternaam is verplicht."
        } else if (gon.locale == "en") {
            "Surname  is required."
        }
    },
    telephoneValidationMessage: function () {
        if (gon.locale == "fr") {
            "Téléphone est nécessaire."
        } else if (gon.locale == "nl") {
            "Telefoon is verplicht."
        } else if (gon.locale == "en") {
            "Telephone is required."
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
            "Numéro de téléphone est nécessaire."
        } else if (gon.locale == "nl") {
            "Telefoonnummer is vereist."
        } else if (gon.locale == "en") {
            "Phone number is required."
        }
    },
    orangePurchaseMessage: function () {
        if (gon.locale == "fr") {
            "SMS code est nécessaire."
        } else if (gon.locale == "nl") {
            "SMS code is vereist."
        } else if (gon.locale == "en") {
            "SMS code is required."
        }
    },
    orangePurchaseMessageSmsCodeValidation: function () {
        if (gon.locale == "fr") {
            "Le code SMS n'est pas correct."
        } else if (gon.locale == "nl") {
            "SMS code is niet juist."
        } else if (gon.locale == "en") {
            "SMS code is not correct."
        }
    }

}