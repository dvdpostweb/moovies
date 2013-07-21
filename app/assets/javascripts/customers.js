$(function() {
	$('body').delegate('.form_ajax',"click", function(){
    $(this).closest("form").ajaxSubmit({success: response_ajax, dataType: 'html'});
    $('.bouton_probleme').html("<div style='height:42px'><img src='/assets/ajax-loader.gif'/></div>")
    return false; // prevent default behaviour
  });
  function response_ajax(responseText, statusText)  {
    if(jQuery.trim(responseText) == "Success"){
      $.facebox.close;
      window.location.href = window.location.pathname;
    } else {
      $('.content').html(responseText);
    }
  }
  
});
