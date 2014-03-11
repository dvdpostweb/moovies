$(function() {
  History = window.History, // Note: We are using a capital H instead of a lower h
  $('#ca-container').contentcarousel({
      // speed for the sliding animation
      sliderSpeed     : 500,
      // easing for the sliding animation
      sliderEasing    : 'easeOutExpo',
      // speed for the item animation (open / close)
      itemSpeed       : 500,
      // easing for the item animation (open / close)
      itemEasing      : 'easeOutExpo',
      // number of items to scroll at a time
      scroll          : 6
      
  });
  $('#ca-container2').contentcarousel({
      // speed for the sliding animation
      sliderSpeed     : 500,
      // easing for the sliding animation
      sliderEasing    : 'easeOutExpo',
      // speed for the item animation (open / close)
      itemSpeed       : 500,
      // easing for the item animation (open / close)
      itemEasing      : 'easeOutExpo',
      // number of items to scroll at a time
      scroll          : 6
      
  });
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
   endscroll()
  $('.menu').on('click', function(){
    if(!$(this).next('.nav').is(':visible'))
    {
      $('.nav').hide('fast')
      $(this).next('.nav').show('fast')
    }
  });
  if($('#online #filters').html())
  {
    
    audience_slider_values = {'0': 0, '10': 1, '12': 2, '16': 3, '18': 4};
    $("#audience-slider-range").slider({
      range: true,
      min: 0,
      max: 4,
      values: [audience_slider_values[$("#filters_audience_min").val()], audience_slider_values[$("#filters_audience_max").val()]],
      step: 1,
      change: function(event, ui) {
        actual_audience_values = {'0': 0, '1': 10, '2': 12, '3': 16, '4': 18};
        $("#filters_audience_min").val(actual_audience_values[ui.values[0]]);
        $("#filters_audience_max").val(actual_audience_values[ui.values[1]]);
        submit_online()
      }
    });
    $('.chosen-select').chosen({allow_single_deselect: true}).change(function(){submit_online()});
    $('#date_filters_year_min, #date_filters_year_max').on("change", function(){
      submit_online()
    })
    $("#ratings-slider-range").slider({
      range: true,
      min: 1,
      max: 5,
      values: [$("#filters_rating_min").val(),$("#filters_rating_max").val()],
      step: 1,
      change: function(event, ui) {
        $("#filters_rating_min").val(ui.values[0]);
        $("#filters_rating_max").val(ui.values[1]);
         submit_online()
      }
    });
    $('.packages').on('click', function(){
      $('#filter_online_form').attr('action', $(this).attr('href'))
      $('.packages').removeClass('current')
      $(this).addClass('current')
      submit_online()
      return false;
    })
    
    $('#products_index').delegate("#close_audience", "click", function() {
      $("#audience-slider-range").slider("values", [0,4])
    });
    $('#products_index').delegate("#close_country", "click", function() {
      $('#filters_country_id').val('').trigger('chosen:updated');
      submit_online()
    });
    $('#products_index').delegate("#close_year", "click", function() {
      $('#filters_country_id').val('').trigger('chosen:updated');
      $("#date_filters_year_min").val($("#date_filters_year_min option:first").val());
      $("#date_filters_year_max").val($("#date_filters_year_min option:last").val());
      submit_online()
    });
    $('#products_index').delegate(".links", "change", function(){
      submit_online()
    })
    /*$('#products_index').delegate(".links", "click", function() {
      $('#filters_view_mode').val($(this).attr('data'))
      submit_online()
    })*/
    $('#products_index').delegate("#close_ratings", "click", function() {
      $("#ratings-slider-range").slider("values", [0,18])
    })
    $('#products_index').delegate("#close_audios", "click", function() {
      $('#filters_audio').val('audio...').trigger('chosen:updated');
      submit_online()
    })
    $('#products_index').delegate("#close_subtitles", "click", function() {
      $('#filters_subtitles').val('sub...').trigger('chosen:updated');
      submit_online()
    })
    $('#products_index').delegate("#close_category", "click", function() {
      $('#filters_category_id').val('category').trigger('chosen:updated');
      submit_online()
    })
    $('#products_index').delegate("#close_actor", "click", function() {
      $('#filter_online_form').attr('action', $(this).attr('url'))
      submit_online()
    })
    $('#products_index').delegate("#close_director", "click", function() {
      $('#filter_online_form').attr('action', $(this).attr('url'))
      submit_online()
    })
    $('#products_index').delegate("#close_view_mode", "click", function() {
      $('.links').prop('checked', false);
      submit_online()
    })
    
    $('#products_index').delegate("#pagination.deactive a", "click", function() {
      ajax($(this).attr('href'))
      return false
    })
    
     
  }
  if($('.edit_search_filter #filters').html())
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
    $('#products_index').delegate(".categorie_online", "click", function() {
      
      return false
    })
  }
  function ajax(path)
  {
    $('#products').html("<div style='height:22px'><img src='/assets/ajax-loader.gif'/></div>");
    $.ajax({url: path, dataType: 'script'});
    history.pushState('', 'New Page Title', path);
  }
  function submit_online()
  {
    $('#products').html("<div style='height:22px'><img src='/assets/ajax-loader.gif'/></div>");
    $('#filter_online_form').ajaxSubmit({dataType: 'script'});
    endscroll()
    history.pushState('', 'New Page Title', $('#filter_online_form').attr('action')+"?"+$('#filter_online_form').serialize()+"&ajax=1");
  }
  /*if($('#products_index').length)
  {
    $('#filter_online_form')[0].reset()
      console.log($("#audience-slider-range"))
     $("#audience-slider-range").slider("values", [0,4])
     $("#ratings-slider-range").slider("values", [0,18])
     $('#filters_audio').val('audio...').trigger('chosen:updated');
     $('#filters_subtitles').val('sub...').trigger('chosen:updated');
     $('#filters_category_id').val('category').trigger('chosen:updated');
    
  }*/
  History.Adapter.bind(window,'statechange',function(){ // Note: We are using statechange instead of popstate
  					// Log the State
  					
  					var State = History.getState(); // Note: We are using History.getState() instead of event.state
  					 $('#products').html("<div style='height:22px'><img src='/assets/ajax-loader.gif'/></div>");
  					console.log(State.url)
  					
  					$.ajax({
              url: State.url,
              dataType: 'script',
              type: 'GET',
              data: {},
              success: function(data) {
                
              },
              error: function() {
                
              }
  				});
  })
});

function goToByScroll(id){
  $('html,body').animate({scrollTop: $("#"+id).offset().top},'slow');
}
function endscroll()
{
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
  }
}