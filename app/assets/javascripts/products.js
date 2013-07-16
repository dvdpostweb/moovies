$(function() {
  $("body").delegate("#c-members #pagination a", "click", function() {
    html_item = $(this).parent();
    content = html_item.html();
    html_item.html("<div style='height:24px; margin:10px 0 0 0'><img src='/assets/ajax-loader.gif'/></div>");
    set_page(this.href)
    $.ajax({
      url: this.href,
      dataType: 'html',
      type: 'GET',
      data: {},
      success: function(data) {
        $('#c-members').html(data);
      },
      error: function() {
        html_item.html(content);
      }
    });
    return false;
  });
  $("body").delegate("#c-members #sort", "change", function() {
    loader = 'ajax-loader.gif';
    $(this).parent().ajaxSubmit({success: show_review,dataType: 'html'});
    html_item = $("#c-members");
    content = html_item.html();
    $(this).parent().html("<div style='height:22px'><img src='/assets/"+loader+"'/></div>");
    return false; // prevent default behaviour
  });
  function show_review(responseText, statusText){
    if(jQuery.trim(statusText) == "success"){
      $("#c-members").html(responseText);
    }
    else
    {
      $("#c-members").html(content);
    }
  };
  /* to do */
  if(($('#image_5').attr('src')!=undefined))
  {
  var img = new Image();
  img.onload = function() {
     height_im = this.height
     if(height_im <= 3)
     {
       $('#thumbs-wrap').hide()
     }
  }
  img.src = $('#image_1').attr('src');
  }
  
  $('#uninterested a').click(function() {
    url = $(this).attr('href')
     var regex = new RegExp('.*/products/([0-9]*)/([^?]*)');
    res = regex.exec(url)
    
    if(res[2]=='seen')
    {
      action = 'AlreadySeen'
    }
    else
    {
      action = 'NotInterestedItem'
    }
    send_event('Movie', action, res[1],'')
  });
  $('.normal .preview_box img').click(function() {
    url = $(this).attr('src')
    url = url.replace('screenshots/small/', 'screenshots/big/')
    open_image(url)
  });
  
  $(window).keydown(function(e){
    if ($('#big_image').is(":visible"))
    {
  		switch (e.keyCode) {
  			case 37: // flèche gauche
  				next_prev('minder')
  				break;
  			case 39: // flèche droite
  				next_prev('plus')
  				break;
  		}
  	}
  });
  $('body').delegate('.next_button, .prev_button',"click", function() {
    if($(this).hasClass('next_button'))
    {
      next_prev('plus')
    }
    else
    {
      next_prev('minder')
    }
  });
  function next_prev(operation)
  {
    url = $('#big_image').attr('src')
    l = url.length
    ext = url.substr((l-5),5)
    n = url.substr((l-5),1)
    if(operation == 'plus')
    {
      n = parseInt(n)+1
    }
    else
    {
      n = parseInt(n)-1
    }
    if( n>6 )
    {
      n=1
    }
    if(n<1)
    {
      n=6
    }
    url = url.replace(ext,n+'.jpg')
    open_image(url)
  }
  function open_image(url)
  {
    var img = new Image();
    img.onload = function() {
       height_im = this.height
       width_im = this.width
       if(height_im > 3)
       {
         img = "<div style='width:"+width_im+"px; height:"+height_im+"px; text-align:center;position:relative;margin: 0 0 15px;'><div class='prev_button' style='height:"+height_im+"px'><div class='image_prev'></div></div><div class='next_button' style='height:"+height_im+"px'><div class='image_next'></div>     </div>    <img src='"+url+"' id='big_image'/></div>"
         jQuery.facebox(img);
         
       }
    }
    img.src = url;
    set_page(url)
  }
});

