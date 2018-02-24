$("#promotion_playstation").validate({
    rules: {
        'code': {
            required: true,
            remote: "/api/v1/check_activation_code_presence_playstation"
        },
        'terms': {
            required: true
        }
    },
    messages: {
        'code': {
            required: required_message(),
            remote: remote_message()
        },
        'terms': {
            required: terms_message()
        }
    },
    errorPlacement: function (error, element) {
        $("#promo-code-error").empty();
        error.appendTo('#promo-code-error');
    },
    submitHandler: function (form) {
        window.location.href = gon.customer_session_path + "?code=" + $("#code").val()
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

function remote_message() {
    if (gon.locale == "fr") {
        return " Le code a déjà été utilisé."
    } else if (gon.locale == "nl") {
        return "De code is al gebruikt."
    } else if (gon.locale == "en") {
        return "The code has already been used."
    }
}

function terms_message() {
    if (gon.locale == "fr") {
        return " Vous devez accepter les termes."
    } else if (gon.locale == "nl") {
        return "U moet de voorwaarden accepteren."
    } else if (gon.locale == "en") {
        return "You have to accept the terms."
    }
}