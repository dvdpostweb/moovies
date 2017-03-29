$(document).ready(function () {
    if ((window.location.pathname == "/" + gon.locale + "/mon-compte/password/nouveau")) {
        password();
    } else if ((window.location.pathname == "/" + gon.locale + "/mijn-account/password/nieuw")) {
        password();
    } else if ((window.location.pathname == "/" + gon.locale + "/my-account/password/new")) {
        password();
    }
});

function password() {

    $("#new_customer").validate({
        rules: {
            'customer[email]': {
                required: true,
                email: true,
                remote: "/api/v1/check_presence_of_customer_email"
            }
        },
        messages: {
            'customer[email]': {
                required: required_message(),
                email: email_message(),
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
        errorClass: 'help-block'
    });

}

function min_characters() {
    if (gon.locale == "fr") {
        return "S'il vous plaît entrer au moins 8 caractères."
    } else if (gon.locale == "nl") {
        return "Voer ten minste 8 tekens."
    } else if (gon.locale == "en") {
        return "Please enter at least 8 characters."
    }
}
function equalToMessage() {
    if (gon.locale == "fr") {
        return "Entrez à nouveau la même valeur s'il vous plait."
    } else if (gon.locale == "nl") {
        return "Vul dezelfde waarde opnieuw."
    } else if (gon.locale == "en") {
        return "Please enter the same value again."
    }
}
function required_message() {
    if (gon.locale == "fr") {
        return "Adresse e-mail est nécessaire."
    } else if (gon.locale == "nl") {
        return "E-mailadres is verplicht."
    } else if (gon.locale == "en") {
        return "Email address is required."
    }
}
function required_message_password() {
    if (gon.locale == "fr") {
        return "Mot de passe requis."
    } else if (gon.locale == "nl") {
        return "Een wachtwoord is verplicht."
    } else if (gon.locale == "en") {
        return "Password is required."
    }
}
function required_message_password_confirmation() {
    if (gon.locale == "fr") {
        return "Confirmation mot de passe est nécessaire."
    } else if (gon.locale == "nl") {
        return "Wachtwoord bevestiging nodig is."
    } else if (gon.locale == "en") {
        return "Password confirmation is required."
    }
}
function email_message() {
    if (gon.locale == "fr") {
        return "Format votre adresse email doit être correcte."
    } else if (gon.locale == "nl") {
        return "Formatteren uw e-mail adres moet correct zijn."
    } else if (gon.locale == "en") {
        return "Format your email address must be correct."
    }
}
function remote_message() {
    if (gon.locale == "fr") {
        return "Adresse e-mail ne se trouve pas dans le système."
    } else if (gon.locale == "nl") {
        return "E-mail adres is niet gevonden in het systeem."
    } else if (gon.locale == "en") {
        return "Email address is not found in the system."
    }
}
function remote_message_register() {
    if (gon.locale == "fr") {
        return "Adresse e-mail existe dans le système."
    } else if (gon.locale == "nl") {
        return "E-mailadres bestaat in het systeem."
    } else if (gon.locale == "en") {
        return "Email address exists in the system."
    }
}
function login_password() {
    if (gon.locale == "fr") {
        return "Champ Mot de passe est nécessaire."
    } else if (gon.locale == "nl") {
        return "Password veld is verplicht."
    } else if (gon.locale == "en") {
        return "Password field is required."
    }
}