$("#bnppf_activation_form").validate({
    onkeyup: false,
    onfocusout: false,
    rules: {
        'bnppf_activation_code': {
            required: true
        }
    },
    messages: {
        'bnppf_activation_code': {
            required: required_message()
        }
    },
    errorLabelContainer: "#bnppf_validations_errors",
    submitHandler: function (form) {

        $.ajax({
            method: 'POST',
            url: '/api/v1/check_presence_of_activation_code_bnppf',
            data: {
                'bnppf_activation_code': $.trim($("#bnppf_activation_code").val())
            },
            dataType: 'json',
            success: function (response) {

                if (0 === response.status) {

                    $("#bnppf_activation_code-error_ajax").show().text("").append(response.message).fadeOut(3000);

                } else if (1 === response.status) {

                    var d = response.message.activation_code_validto_date.slice(0, 10).split('-');

                    if (gon.locale == "fr") {

                        var link = "/fr/mon-compte/connectez-vous?code=" + response.message.activation_code + "";

                    } else if (gon.locale == "nl") {

                        var link = "/nl/mijn-account/log-in?code=" + response.message.activation_code + "";

                    } else if (gon.locale == "en") {

                        var link = "/en/my-account/log-in?code=" + response.message.activation_code + "";

                    }

                    var success_message_paribas = "<div>" +
                        "<label class=\"info-label\">" + response.bnppf_6 + "</label>" +
                        "<label class=\"info-label\"><b>" + response.message.tvod_free + " " + response.bnppf_7 + "</b></label>" +
                        "</div>" +
                        "<div>" +
                        "<label class=\"info-label\">" + response.bnppf_9 + "</label>" +
                        "<label class=\"info-label\"><b>" + d[1] +'/'+ d[2] +'/'+ d[0] + "</b></label>" +
                        "<div>" +
                        "<a href=" + link + " class=\"button-connenct button-tm\">" + response.bnppf_10 + "</a>";

                    $("#promotion_result_paribas").html("").append(success_message_paribas)

                }

            },
            error: function (response) {
                console.log('PARIBAS SYSTEM ERROR!!!');
            }
        });

    }
});

function required_message() {
    if (gon.locale == "fr") {
        return "Code d'activation est nécessaire."
    } else if (gon.locale == "nl") {
        return "Activatie code is verplicht."
    } else if (gon.locale == "en") {
        return "Activation code is required."
    }
}

function float2int(value) {
    return value | 0;
}

function getFormattedDate(date) {
    var year = date.getFullYear();
    var month = (1 + date.getMonth()).toString();
    month = month.length > 1 ? month : '0' + month;
    var day = date.getDate().toString();
    day = day.length > 1 ? day : '0' + day;
    return month + '/' + day + '/' + year;
}