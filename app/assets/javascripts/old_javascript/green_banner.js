$(document).ready(function() {
	$(".abo_subscriber").click(function(e) {
		e.preventDefault();
		$(".tvod").trigger("click");
	});
	$(".unlimited_subscriber").click(function(e) {
		e.preventDefault();
		$(".svod").trigger("click");
	});
	$("#trg").click(function() {
		$(".public_promo_btn").trigger("click");
	});	

    $("#green_banner_form").submit(function(event) {
      event.preventDefault();
      $.ajax({
        method: 'POST',
        url: '/api/v1/promotion_code_activation',
        data: {
          'promotion': $("#promotion").val()
        },
        dataType: 'json',
          success: function (response) {
    	    if (1 === response.status) {
    	      $("#promotion_response_message").html(response.message);
          } else if (2 === response.status) {
            window.location.href = response.message;
          }
        }
      });
    });
});