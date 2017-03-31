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
        highlight: function(element) {
            $(element).closest('.form-group').addClass('has-error');
        },
        unhighlight: function(element) {
            $(element).closest('.form-group').removeClass('has-error');
        },
        errorElement: 'span',
        errorClass: 'help-block',
        submitHandler: function (form) {
            $.ajax({
                method: 'POST',
                url: '/orange/lu/api/is_eligable',
                data: {
                    'sms_number': $.trim($("#sms_number").val())//,
                    //'password': $("#customer_password").val(),
                    //'code': gon.code,
                    //'moovie_id': gon.moovie_id,
                    //'activation': gon.activation,
                    //'samsung': gon.samsung,
                    //'kind': gon.kind
                },
                dataType: 'json',
                success: function (response) {
                    if (0 === response.status) {
                        $("#info").html(successMessage(response.message)).fadeOut(3000);
                        $("#is_eligable").hide();
                        $("#orange_purchase").show();
                    } else if (1 === response.status) {
                        $("#info").append(errorMessage(response.message));
                    //    window.location.href = response.message
                    //} else if (3 === response.status) {
                    //    $("#code_info").show().fadeOut(3000);
                    //    $("#code_message").text("");
                    //    $("#code_message").append(response.message);
                    //} else if (5 === response.status) {
                    //    $("#code_info").show().fadeOut(3000);
                    //    $("#code_message").text("");
                    //    $("#code_message").append(response.message);
                    //} else if (4 === response.status) {
                    //    window.location.href = response.message
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
                required: true
            }
        },
        messages: {
            "sms-code": {
                required: orangePurchaseMessage()
            }
        },
        highlight: function(element) {
            $(element).closest('.form-group').addClass('has-error');
        },
        unhighlight: function(element) {
            $(element).closest('.form-group').removeClass('has-error');
        },
        errorElement: 'span',
        errorClass: 'help-block',
        submitHandler: function (form) {
            $.ajax({
                method: 'POST',
                url: '/orange/lu/api/orange_purchase',
                data: {
                    'sms_code': $.trim($("#sms_code").val())//,
                    //'password': $("#customer_password").val(),
                    //'code': gon.code,
                    //'moovie_id': gon.moovie_id,
                    //'activation': gon.activation,
                    //'samsung': gon.samsung,
                    //'kind': gon.kind
                },
                dataType: 'json',
                success: function (response) {
                    if (0 === response.status) {
                        $("#info").html(successMessage(response.message)).fadeOut(3000);
                        //$("#sms_form").empty();//.html(orangePurchaseForm());
                    } else if (1 === response.status) {
                        $("#info").append(errorMessage(response.message));
                        //    window.location.href = response.message
                        //} else if (3 === response.status) {
                        //    $("#code_info").show().fadeOut(3000);
                        //    $("#code_message").text("");
                        //    $("#code_message").append(response.message);
                        //} else if (5 === response.status) {
                        //    $("#code_info").show().fadeOut(3000);
                        //    $("#code_message").text("");
                        //    $("#code_message").append(response.message);
                        //} else if (4 === response.status) {
                        //    window.location.href = response.message
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
        return "Numéro de téléphone est nécessaire."
    } else if (gon.locale == "nl") {
        return "Telefoonnummer is vereist."
    } else if (gon.locale == "en") {
        return "Phone number is required."
    }
}

function successMessage(message) {
    return successMessage = "<div class=\"alert alert-success\">" +
        "<strong>" + message + "</strong>" +
        "</div>";
}

function errorMessage(message) {
    return errorMessage = "<div class=\"alert alert-danger\">" +
        "<strong> + message + </strong>" +
        "</div>";
}
