$("#form_step").validate({
    rules: {
        'code': {
            required: true,
            remote: "/api/v1/check_presence_of_activation_code_orange"
        }
    },
    messages: {
        'code': {
            required: required_message(),
            remote: remote_message()
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