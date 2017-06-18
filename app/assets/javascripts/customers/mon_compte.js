$(document).ready(function () {

    monCompte.urlValidator();

});

var monCompte = {

    urlValidator: function () {

        if ((window.location.pathname == "/" + gon.locale + "/mon-compte/" + gon.customer)) {

            //self.monCompte.bootstrapDatepicker();

        } else if ((window.location.pathname == "/" + gon.locale + "/mijn-account/" + gon.customer)) {

            //self.monCompte.bootstrapDatepicker();

        } else if ((window.location.pathname == "/" + gon.locale + "/my-account/" + gon.customer)) {

            //self.monCompte.bootstrapDatepicker();

        }

    }//,


}

