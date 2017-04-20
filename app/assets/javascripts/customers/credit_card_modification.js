$(document).ready(function () {

    $("#accordion").accordion({
    	heightStyle: "content"
    });

    step3.validateVirmanForm();

    step3.validateBancCard();

});

var step3 = {

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

            highlight: function(element) {

                $(element).closest('.form-group').addClass('has-error');

            },

            unhighlight: function(element) {

                $(element).closest('.form-group').removeClass('has-error');

            },

            errorElement: 'span',

            errorClass: 'help-block'

        });

    },
    firstNameValidationMessage: function () {

        if (gon.locale == "fr") {

            return "Prénom est nécessaire."

        } else if (gon.locale == "nl") {

            return "Voornaam is verplicht."

        } else if (gon.locale == "en") {

            return "First name is required."

        }

    },
    lastNameValidationMessage: function () {

        if (gon.locale == "fr") {

            return "Nom de famille est nécessaire."

        } else if (gon.locale == "nl") {

            return "Achternaam is verplicht."

        } else if (gon.locale == "en") {

            return "Surname  is required."

        }

    },
    telephoneValidationMessage: function () {

        if (gon.locale == "fr") {

            return "Téléphone est nécessaire."

        } else if (gon.locale == "nl") {

            return "Telefoon is verplicht."

        } else if (gon.locale == "en") {

            return "Telephone is required."

        }

    },
    validateBancCard: function() {

        $("#payment_methods").submit(function() {

            if (!$("input[name='brand']").is(":checked")) {

                $("#banc_card_error").empty().html("<div class=\"alert alert-danger\" role=\"alert\">" + gon.banc_card_error_message + "</div>");

                return false;

            }

        });

    }

}