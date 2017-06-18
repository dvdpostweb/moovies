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
  $("#moncompte").delegate(".suppendre_newsletter, .suppendre_newsletter_parnter", "click", function() {
    url = $(this).attr('href');
    html_item = $(this).parent();
    content = html_item.html();
    html_item.html("<div style='height:20px'><img src='/assets/ajax-loader.gif'/></div>");
    $.ajax({dataType: 'html',
      url: url,
      type: 'POST',
      data: {},
      success: function(data) {
        item = html_item.html(data);
      },
      error: function() {
        html_item.html(content);
      }
    });
    return false;
  });
  $('#moncompte').delegate("#new_suspension", "click", function(){
    $('#new_suspension').html("<div style='height:32px'><img src='/assets/ajax-loader.gif' /></div>")
    $('#suspend-abonament form').ajaxSubmit(options);
    return false; // prevent default behaviour
  });
  
  var options = {
    success: showResponse,
    dataType: 'html'  // post-submit callback
  };

  // post-submit callback
  function showResponse(responseText, statusText)  {
    if(jQuery.trim(responseText) == "Success"){
      $.facebox.close;
      window.location.href = window.location.pathname;
    } else {
      $('.content').html(responseText);
    }
  }
});
