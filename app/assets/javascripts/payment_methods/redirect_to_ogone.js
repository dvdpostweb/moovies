$(document).ready(function () {

    paymentMethods.validatePaymentMethodsUrl();

});

var paymentMethods = {

    validatePaymentMethodsUrl: function () {

        if (window.location.pathname == "/" + gon.locale + "/mon-compte/" + gon.current_customer_id + "/payment_methods") {

            this.submitOgoneForm();

        } else if (window.location.pathname == "/" + gon.locale + "/mijn-account/" + gon.current_customer_id + "/payment_methods") {

            this.submitOgoneForm();

        } else if (window.location.pathname == "/" + gon.locale + "/my-account/" + gon.current_customer_id + "/payment_methods") {

            this.submitOgoneForm();

        }

    },
    submitOgoneForm: function() {

        setTimeout(function(){

            $("#checkout_confirmation").submit();

        },5000);

    }

}