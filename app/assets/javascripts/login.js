$(document).ready(function () {
    if ((window.location.pathname == "/" + gon.locale + "/mon-compte/connectez-vous")) {
        login();
    } else if ((window.location.pathname == "/" + gon.locale + "/mijn-account/log-in")) {
        login();
    } else if ((window.location.pathname == "/" + gon.locale + "/my-account/log-in")) {
        login();
    }
});

function login() {

    $('#customer_email').val("");
    $('#customer_password').val("");
    $('#customer_email').bind("cut copy paste", function (e) {
        e.preventDefault();
    });
    $('#customer_password').bind("cut copy paste", function (e) {
        e.preventDefault();
    });
    $("#new_customer").validate({
        rules: {
            'customer[email]': {
                required: true,
                email: true,
                remote: "/api/v1/check_presence_of_customer_email"
            },
            'customer[password]': {
                required: true,
                remote: {
                    url:"/api/v1/validate_login_password",
                    data: {
                        "customer[email]": function(){
                            return $.trim($("#customer_email").val())
                        }
                    },
                    async: false
                }
            }
        },
        messages: {
            'customer[email]': {
                required: required_message(),
                email: email_message(),
                remote: remote_message()
            },
            'customer[password]': {
                required: login_password()
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
                url: '/api/v1/login',
                data: {
                    'email': $("#customer_email").val(),
                    'password': $("#customer_password").val(),
                    'code': gon.code,
                    'moovie_id': gon.moovie_id,
                    'activation': gon.activation,
                    'samsung': gon.samsung,
                    'kind': gon.kind
                },
                dataType: 'json',
                success: function (response) {
                    if (0 === response.status) {
                        $("#password_info").show().fadeOut(3000);
                        $("#password_message").text("");
                        $("#password_message").append(response.message);
                    } else if (1 === response.status) {
                        window.location.href = response.message
                    } else if (3 === response.status) {
                        $("#code_info").show().fadeOut(3000);
                        $("#code_message").text("");
                        $("#code_message").append(response.message);
                    } else if (5 === response.status) {
                        $("#code_info").show().fadeOut(3000);
                        $("#code_message").text("");
                        $("#code_message").append(response.message);
                    } else if (4 === response.status) {
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
