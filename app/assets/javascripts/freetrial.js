$( document ).ready(function() {
    if (window.location.pathname == "/en/freetrial" || window.location.pathname == "/fr/freetrial" || window.location.pathname == "/nl/freetrial") {
       if (gon.current_customer.social_network_tag === "facebook" && gon.current_customer.facebook_activation === 0 && gon.current_customer.customers_registration_step === 972) {
         $("#photobox-btn").click(function() {
			if ($('#select-offer-2').is(':checked')) {
		       console.log(gon.case2FILMSFREE);
	    	} else if ($('#select-offer-4').is(':checked')) {
	    		console.log(gon.case4FILMSFREE);
	    	} else if ($('#select-offer-6').is(':checked')) {
	    		console.log(gon.case6FILMSFREE);
	    	} else {
	    		$(".photobox-error").show().fadeOut(3000);
	    	}
    	 });
       } else {
       	$("#photobox-btn").click(function() {
			if ($('#select-offer-2').is(':checked')) {
		       window.location.href = gon.case2FILMSFREE
	    	} else if ($('#select-offer-4').is(':checked')) {
	    		window.location.href = gon.case4FILMSFREE
	    	} else if ($('#select-offer-6').is(':checked')) {
	    		window.location.href = gon.case6FILMSFREE
	    	} else {
	    		$(".photobox-error").show().fadeOut(3000);
	    	}
    	});
       }
    }
});
