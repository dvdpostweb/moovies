$( document ).ready(function() {
    if (window.location.pathname == "/en/photobox" || window.location.pathname == "/fr/photobox" || window.location.pathname == "/nl/photobox") {
    	$("#photobox-btn").click(function() {
			if ($('#select-offer-2').is(':checked')) {
		       window.location.href = gon.case2FILMS75
	    	} else if ($('#select-offer-4').is(':checked')) {
	    		window.location.href = gon.case4FILMS75
	    	} else if ($('#select-offer-6').is(':checked')) {
	    		window.location.href = gon.case6FILMS75
	    	} else {
	    		$(".photobox-error").show().fadeOut(3000);
	    	}
    	});
    }
});