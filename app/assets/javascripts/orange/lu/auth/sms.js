$(document).ready(function () {

    if ((window.location.pathname == "/orange/lu/auth/" + gon.locale + "/sms/authorization")) {
        isEligable();
        orangePurchase();
    }

});

function isEligable() {

    $("#is_eligable").validate({
        rules: {
            "phone-number": {
                required: true
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
                url: '/orange/lu/api/is_eligable',
                data: {
                    'sms_number': $.trim($("#sms_number").val())
                },
                dataType: 'json',
                success: function (response) {
                    if (0 === response.status) {
                        successMessage = "<div class=\"alert alert-success\">" +
                            "<strong>" + response.message + "</strong>" +
                            "</div>";
                        $("#info1").html(successMessage).fadeOut(3000);
                        $("#is_eligable").hide();
                        $("#orange_purchase").show();
                        $("#sms_code").val(response.sms_code);
                    } else if (1 === response.status) {
                        $("#info1").append(errorMessage(response.message));
                    }
                },
                error: function (response) {
                    console.log('CHECKED AJAX ERROR!!!');
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
                    'sms_code': $.trim($("#sms_code").val())
                },
                dataType: 'json',
                success: function (response) {
                    if (0 === response.status) {
                        successMessage = "<div class=\"alert alert-success\">" +
                            "<strong>" + response.message + "</strong>" +
                            "</div>";
                        $("#info2").html(successMessage).fadeOut(3000);
                        //$("#sms_form").empty();//.html(orangePurchaseForm());
                    } else if (1 === response.status) {
                        $("#info2").append(errorMessage(response.message));
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
