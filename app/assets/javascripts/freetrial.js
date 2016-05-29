$(document).ready(function() {
    if (window.location.pathname == "/" + gon.locale + "/freetrial") {
       if ((typeof gon !== "undefined" && gon !== null) && gon.current_customer !== null) {
         if ((typeof gon !== "undefined" && gon !== null) && gon.current_customer.social_network_tag !== null && gon.current_customer.facebook_activation !== null && gon.current_customer.customers_registration_step !== null) {

         $("#photobox-btn").click(function() {
			if ($('#select-offer-2').is(':checked')) {
		       $.ajax({
	                method: 'POST',
	                url: '/social_activation',
	                data: {
	                    'customer_email': gon.current_customer.email,
	                    'activation_dicsount_code_id': 3
	                },
	                dataType: 'json',
	                success: function (response) {
	                    if (1 === response.status) {
	                    	window.location.href = "/en/steps/step2"
	                    }
	                },
	                error: function (response) {
	                    console.log('CHECKED AJAX ERROR!!!');
	                }
	            });
	    	} else if ($('#select-offer-4').is(':checked')) {
	    		$.ajax({
	                method: 'POST',
	                url: '/social_activation',
	                data: {
	                    'customer_email': gon.current_customer.email,
	                    'activation_dicsount_code_id': 3
	                },
	                dataType: 'json',
	                success: function (response) {
	                    if (1 === response.status) {
	                        window.location.href = "/en/steps/step2"
	                    }
	                },
	                error: function (response) {
	                    console.log('CHECKED AJAX ERROR!!!');
	                }
	            });
	    	} else if ($('#select-offer-6').is(':checked')) {
	    		$.ajax({
	                method: 'POST',
	                url: '/social_activation',
	                data: {
	                    'customer_email': gon.current_customer.email,
	                    'activation_dicsount_code_id': 3
	                },
	                dataType: 'json',
	                success: function (response) {
	                    if (1 === response.status) {
	                        window.location.href = "/en/steps/step2"
	                    }
	                },
	                error: function (response) {
	                    console.log('CHECKED AJAX ERROR!!!');
	                }
	            });
	    	} else {
	    		$(".photobox-error").show().fadeOut(3000);
	    	}
    	 });
     }
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