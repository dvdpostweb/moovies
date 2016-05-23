$(document).ready(function() {
	if (gon.current_customer.social_network_tag !== null && gon.current_customer.facebook_activation !== null && gon.current_customer.customers_registration_step !== null && window.location.pathname != "/" + gon.locale + "/freetrial") {
		$("#top").hide();
		$("#lang").hide();
		$("#wrap").hide();
		$("#footer").hide();
		$("body").removeClass("normal private en not_reload");
		window.location.href = window.location.origin + "/" + gon.locale + "/freetrial";
	}
});