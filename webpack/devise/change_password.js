$(document).ready(function () {

    changePasswordValidation.validatechangePasswordValidationUrl();

});

var changePasswordValidation = {

    validatechangePasswordValidationUrl: function () {

        this.formValidation();

    },
    formValidation: function () {

        $("#edit_customer").validate({

            rules: {

                'customer[email]': {

                    required: true,

                    email: true

                },

                'customer[current_password]': {

                    required: true,

                    remote: {
                        url: "/api/v1/validate_login_password_on_update",
                        data: {
                            "customer[email]": function () {
                                return $.trim($("#customer_email").val())
                            }
                        },
                        async: false
                    }

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

                'customer[current_password]': {

                    required: this.formOldPasswordRequiredMessage(),

                    remote: this.formOldPasswordRemoteMessage()

                },

                'customer[password]': {

                    required: this.formNewPasswordRequiredMessage(),

                    minlength: this.formNewPasswordMinCharactersMessage()

                },

                'customer[password_confirmation]': {

                    required: this.formNewPassworConfirmationdRequiredMessage(),

                    equalTo: this.formNewPasswordEqualToMessage()

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

        })

    },

    formOldPasswordRequiredMessage: function () {

        if (gon.locale == "fr") {

            return "Votre mot de passe actuel est nécessaire."

        } else if (gon.locale == "nl") {

            return "Uw huidige wachtwoord is vereist."

        } else if (gon.locale == "en") {

            return "Your current password is required."

        }

    },

    formOldPasswordRemoteMessage: function () {

        if (gon.locale == "fr") {

            return "S'il vous plaît entrer le mot de passe actuel correct."

        } else if (gon.locale == "nl") {

            return "Voer het juiste huidige wachtwoord."

        } else if (gon.locale == "en") {

            return "Please enter the correct current password."

        }

    },

    formNewPasswordRequiredMessage: function () {

        if (gon.locale == "fr") {

            return "Votre nouveau mot de passe est nécessaire."

        } else if (gon.locale == "nl") {

            return "Uw nieuwe wachtwoord is vereist."

        } else if (gon.locale == "en") {

            return "Your new password is required."

        }

    },

    formNewPassworConfirmationdRequiredMessage: function () {

        if (gon.locale == "fr") {

            return "Confirmation de votre nouveau mot de passe est nécessaire."

        } else if (gon.locale == "nl") {

            return "Bevestiging van het nieuwe wachtwoord nodig."

        } else if (gon.locale == "en") {

            return "Confirmation of your new password is required."

        }

    },

    formNewPasswordMinCharactersMessage: function () {

        if (gon.locale == "fr") {

            return "S'il vous plaît entrer au moins 8 caractères."

        } else if (gon.locale == "nl") {

            return "Voer ten minste 8 tekens."

        } else if (gon.locale == "en") {

            return "Please enter at least 8 characters."

        }

    },

    formNewPasswordEqualToMessage: function () {

        if (gon.locale == "fr") {

            return "Entrez à nouveau la même valeur s'il vous plait."

        } else if (gon.locale == "nl") {

            return "Vul dezelfde waarde opnieuw."

        } else if (gon.locale == "en") {

            return "Please enter the same value again."

        }

    }

}