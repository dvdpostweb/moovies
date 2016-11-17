if (window.location.pathname === "/" + gon.locale + "/freetrial_action") {

  $(document).ready(function() {

    validateFreeTrialLogin();

    validateFreeTrialRegister();

  });

}

function validateFreeTrialLogin() {

  $("#FreeTrialLogin").validate({
    rules: {
      "FreeTrialLoginEmailAddress": {
        required: true,
        email: true,
        remote: "/api/v1/ft/l_v"
      },
      "FreeTrialLoginEmailPassword": {
        required: true,
        remote: {
          url:"/api/v1/ft/l_p_v",
          data: {
            "FreeTrialLoginEmailAddress": function(){
              return $.trim($("#FreeTrialLoginEmailAddress").val())
            }
          },
          async: false
        }
      }
    },
    messages: {
      "FreeTrialLoginEmailAddress": {
        required: required_message(),
        email: email_message(),
        remote: remote_message()
      },
      "FreeTrialLoginEmailPassword": {
        required: login_password(),
        remote: incorect_password()
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
    errorPlacement: function(error, element) {
    if(element.parent('.input-group').length) {
      error.insertAfter(element.parent());
    } else {
      error.insertAfter(element);
    }
    },
    submitHandler: function (form) {
      $.ajax({
        method: 'POST',
        url: '/api/v1/ft/login',
        data: {
          'email': $.trim($("#FreeTrialLoginEmailAddress").val()),
          'password': $.trim($("#FreeTrialLoginEmailPassword").val()),
          'code': $.trim(gon.code)
        },
        dataType: 'json',
        success: function (response) {
          if (0 === response.status) {
            $("#FreeTrialLoginError").show();
            $("#FreeTrialLoginError").text("");
            $("#FreeTrialLoginError").append(response.message);
          } else if (1 === response.status) {
            window.location.href = response.message
          } else if (3 === response.status) {
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

function validateFreeTrialRegister() {

  if ($("#customer_newsletter").is(':checked')) {
    customers_newsletter = 1
    $("#customer_newsletter").click(function() {
      if ($(this).is(':checked')) {
        customers_newsletter = 1
      } else {
        customers_newsletter = 0
      }
    });
  }

  if ($("#customer_newsletter_parnter").is(':checked')) {
    customers_newsletterpartner = 1
    $("#customer_newsletter_parnter").click(function() {
      if ($(this).is(':checked')) {
        customers_newsletterpartner = 1
      } else {
        customers_newsletterpartner = 0
      }
    });
  }

  $("#FreeTrialRegister").validate({
    rules: {
      "FreeTrialLoginEmailAddress": {
        required: true,
        email: true,
        remote: "/api/v1/ft/r_v"
      },
      "FreeTrialLoginEmailPassword": {
        required: true,
        minlength: 8
      },
      "FreeTrialLoginEmailPasswordConfirmation": {
        required: true,
        minlength: 8,
        equalTo: "#FreeTrialLoginEmailPassword"
      }
    },
    messages: {
      "FreeTrialLoginEmailAddress": {
        required: required_message(),
        email: email_message(),
        remote: remote_message_register()
      },
      "FreeTrialLoginEmailPassword": {
        required: required_message_password(),
        minlength: min_characters()
      },
      "FreeTrialLoginEmailPasswordConfirmation": {
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
    errorPlacement: function(error, element) {
    if(element.parent('.input-group').length) {
      error.insertAfter(element.parent());
    } else {
      error.insertAfter(element);
    }
    },
    submitHandler: function (form) {
      $.ajax({
        method: 'POST',
        url: '/api/v1/ft/register',
        data: {
          'email': $.trim($("#FreeTrialLoginEmailAddress").val()),
          'password': $.trim($("#FreeTrialLoginEmailPassword").val()),
          'password_confirmation': $.trim($("#FreeTrialLoginEmailPasswordConfirmation").val()),
          'code': $.trim(gon.code)
          //'customers_newsletter': customers_newsletter,
          //'customers_newsletterpartner': customers_newsletterpartner
        },
        dataType: 'json',
        success: function (response) {
          if (1 === response.status) {
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

function incorect_password() {
  if (gon.locale == "fr") {
    return "Votre mot de passe est incorrect."
  } else if (gon.locale == "nl") {
    return "Jouw wachtwoord is incorrect."
  } else if (gon.locale == "en") {
    return "Your password is incorrect."
  }
}
