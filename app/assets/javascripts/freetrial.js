$( document ).ready(function() {
    if (window.location.pathname == "/en/freetrial" || window.location.pathname == "/fr/freetrial" || window.location.pathname == "/nl/freetrial") {
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
});
