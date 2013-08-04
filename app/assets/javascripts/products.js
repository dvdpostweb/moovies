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
  /***trailer ***/
  $('body').delegate(".linkallversions a", "click", function() {
    html_item = $(this);
    content = html_item.html();
    html_item.html("Loading...");
    root_item = $('#content_trailer');
    
    set_page(html_item.attr('href'))
    $.ajax({dataType: 'html',
      url: html_item.attr('href'),
      type: 'GET',
      data: {},
      success: function(data) {
        root_item.html(data);
      },
      error: function() {
        html_item.html(content);
      }
    });
    return false;
  });
  $('body').delegate('.streaming_add_list, .streaming_remove_list', "click", function(){
     $(this).parent().ajaxSubmit({dataType: 'script'});
     $(this).parent().html("<div class='load2'><img src='/assets/ajax-loader.gif' /></div>")
     return false; // prevent default behaviour
   });
   $('#toTop').on('click', function(){
     goToByScroll('top')
   });
   if ($('#products_index #pagination.active').length) {
       $(window).scroll(function() {
         var path;
         path = $('#products_index #pagination .next_page').attr('href');
         if ($(window).scrollTop() < 500)
         {
           $('#toTop').fadeOut('slow')
         }
         else
         {
           $('#toTop').fadeIn('slow')
         }
         if (path && $(window).scrollTop() > $(document).height() - $(window).height() - 1200) {
           set_page(path)
           $('#pagination').html("<img src='/assets/loading.gif' />");
           return $.ajax({url: path, dataType: 'script'});
         }
       });
       /*return $(window).scroll();*/
   }
  $('.menu').on('click', function(){
    if(!$(this).next('.nav').is(':visible'))
    {
      $('.nav').hide('fast')
      $(this).next('.nav').show('fast')
    }
  });
  
  if($('#filters').html())
  {
    $("#filters ul li a").on("click", function() {
      $(this).parent().toggleClass('open');
      $(this).parent().children("div").toggle();
      return false;
    });
    audience_slider_values = {'0': 0, '10': 1, '12': 2, '16': 3, '18': 4};
    $("#audience-slider-range").slider({
      range: true,
      min: 0,
      max: 4,
      values: [audience_slider_values[$("#search_filter_audience_min").val()], audience_slider_values[$("#search_filter_audience_max").val()]],
      step: 1,
      slide: function(event, ui) {
        actual_audience_values = {'0': 0, '1': 10, '2': 12, '3': 16, '4': 18};
        $("#search_filter_audience_min").val(actual_audience_values[ui.values[0]]);
        $("#search_filter_audience_max").val(actual_audience_values[ui.values[1]]);
      }
    });
    $("#ratings-slider-range").slider({
      range: true,
      min: 1,
      max: 5,
      values: [$("#search_filter_rating_min").val(),$("#search_filter_rating_max").val()],
      step: 1,
      slide: function(event, ui) {
        $("#search_filter_rating_min").val(ui.values[0]);
        $("#search_filter_rating_max").val(ui.values[1]);
      }
    });
  }
});

function goToByScroll(id){
  $('html,body').animate({scrollTop: $("#"+id).offset().top},'slow');
}