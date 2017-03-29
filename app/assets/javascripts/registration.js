$(document).ready(function () {
    if ((window.location.pathname == "/" + gon.locale + "/mon-compte/sign_up")) {
        register();
    } else if ((window.location.pathname == "/" + gon.locale + "/mijn-account/sign_up")) {
        register();
    } else if ((window.location.pathname == "/" + gon.locale + "/my-account/sign_up")) {
        register();
    }
});

function register() {

    if ($("#customer_newsletter").is(':checked')) {
        customers_newsletter = 1
        $("#customer_newsletter").click(function () {
            if ($(this).is(':checked')) {
                customers_newsletter = 1
            } else {
                customers_newsletter = 0
            }
        });
    }

    if ($("#customer_newsletter_parnter").is(':checked')) {
        customers_newsletterpartner = 1
        $("#customer_newsletter_parnter").click(function () {
            if ($(this).is(':checked')) {
                customers_newsletterpartner = 1
            } else {
                customers_newsletterpartner = 0
            }
        });
    }

    $("#new_customer").validate({
        rules: {
            'customer[email]': {
                required: true,
                email: true,
                remote: "/api/v1/check_presence_of_customer_email_registration"
            },
            'customer[password]': {
                required: true,
                minlength: 8
            },
            'customer[password_confirmation]': {
                required: true,
                minlength: 8,
                equalTo: "#customer_password"
            }
        },
        messages: {
            'customer[email]': {
                required: required_message(),
                email: email_message(),
                remote: remote_message_register()
            },
            'customer[password]': {
                required: required_message_password(),
                minlength: min_characters()
            },
            'customer[password_confirmation]': {
                required: required_message_password_confirmation(),
                minlength: min_characters(),
                equalTo: equalToMessage()
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
                url: '/api/v1/register',
                data: {
                    'email': $("#customer_email").val(),
                    'password': $("#customer_password").val(),
                    'password_confirmation': $("#customer_password_confirmation").val(),
                    'code': gon.code,
                    'moovie_id': gon.moovie_id,
                    'activation': gon.activation,
                    'customers_newsletter': customers_newsletter,
                    'customers_newsletterpartner': customers_newsletterpartner
                },
                dataType: 'json',
                success: function (response) {
                    if (9 === response.status) {
                        window.location.href = response.message
                    }
                },
                error: function (response) {
                    console.log('CHECKED AJAX ERROR!!!');
                }
            });
        }
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