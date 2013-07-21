// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery.form

//= require jquery.ui.datepicker
//= require jquery.ui.datepicker-fr
//= require facebox
//= require messages
//= require reviews
//= require products
//= require actors
//= require customers
$(function() {
  $('.facebox').on('click', function() {
    item = $(this);
    url = item.attr('href')
    jQuery.facebox(function() {
      $.ajax({
        url: url,
        dataType: 'html',
        type: 'GET',
        success: function(data) { jQuery.facebox(data); }
      });
    });
    return false;
  });
  $('#catalogue_menu, #account_menu').on('mouseover',function(){
    id = $(this).attr('id').replace('_menu','')
    $('#'+id).show()
  })
  $('.dropdown').on('mouseleave',function(){
    id = $(this).attr('id').replace('_menu','')
    $('#'+id).hide()
  })
  $('body').delegate("#new_review .star", "mouseover", function(){
    data = $(this).attr('id').replace('star_','').split('_');
    product_id = data[0];
    rating_value = data[1];

    image = 'star-voted-';
    if ($(this).attr('src').match(/black-star-(on|half|off)/i)){
      image = 'black-'+image;
    }
    for(var i=1; i<=5; i++)
    {
      if(i <= rating_value){
        full_image = image+'on';
      }else{
        full_image = image+'off';
      }
      $('#new_review #star_'+product_id+"_"+i).attr('src', '/assets/'+full_image+'.png');
    }
  });
  $('body').delegate("#new_review .star", "mouseout", function() {
    product_id = $(this).attr('id').replace('star_','').split('_')[0];
    for(var i=1; i<=5; i++)
    {
      image = $('#new_review #star_'+product_id+'_'+i);
      image.attr('src','/assets/'+image.attr('name'));
    }
  });
  $('body').delegate("#new_review .star", "click", function(){
    url = $(this).parent().attr('href');
    var value = querySt(url,'value');
    $('#review_rating').val(value);
    image = 'star-voted-';    
    for(var i=1; i<=5; i++)
    {
      if(i <= value){
        full_image = image+'on';
      }else{
        full_image = image+'off';
      }
      $('#new_review #star_'+product_id+"_"+i).attr('name', full_image+'.png');
      
    }
    return false;
  });
  $("body").delegate(".yn .yes, .yn .no", "click",function(){
     $(this).parent("p.yn").html('<img src="/assets/ajax-loader.gif" />');
     review_id = $(this).attr('review_id');
     html_item = $('#critique'+review_id);
     content = html_item.html();
     set_page($(this).attr('href'))
     $.ajax({dataType: 'html', url: $(this).attr('href'),  type: 'POST', data: {}, success: function(data) { html_item.replaceWith(data); }, error: function() { html_item.html(content);}});
     return false;
   });
   $("body").delegate("#review_submit", 'click',function(){
     value = parseInt($('#review_rating').attr('value'),10);
     if( value == 0 || value > 5 )
     {
       alert($('#popup_rating_error').html())
       return false;
     }
     t=$('#review_text').val()
     i=$('.cover').children().children().attr('src')
     id=$('#review_product_id').html()
     local=$('#review_locale').html()
     title = $('#detail-wrap h2').html()
     /*#todo
     f=$('#facebook').attr('checked')?1:0;
     if(f==1)
     {
       postToFeed(t, i, local, id, title, 'www.dvdpost.be' );
     }*/
     set_page($("#new_review").attr('action'))
     $("#new_review").ajaxSubmit({dataType: 'script'});
     $("#review_submit").parent().html("<div style='height:42px'><img src='/assets/ajax-loader.gif'/></div>")
     return false;
   });
   
   $('body').delegate(".stars .star", "click", function() {
     url = $(this).parent().attr('href');
     html_item = $(this).parent().parent();
     content = html_item.html();
     loader = 'ajax-loader.gif';
     if ($(this).attr('src').match(/black-star-/i)){
       loader = 'black-'+loader;
     }
     html_item.html("<div style='height:19px'><img src='/assets/"+loader+"'/></div>");
     set_page(url)
     var regex = new RegExp(".*/products/([0-9]*).*value=([0-9])");
     res = regex.exec(url)
     send_event('Movie', 'ItemRated', res[1], res[2])

     $.ajax({dataType: 'html',
       url: url,
       type: 'POST',
       data: {},
       success: function(data) {
         $('.tooltip_items').hide()
         if (url.match(/replace=homepage/)){
           if(data.match(/user-movies-wrap/))
           {
             html_item.parent().parent().parent().parent().replaceWith(data);  
           }
           else
           {
             html_item.parent().parent().parent().replaceWith(data);  
           }
         }else{
           html_item.html(data);
         }

       },
       error: function() {
         html_item.html(content);
       }
     });

     return false;
   });

   $('body').delegate(".stars .star", "mouseover", function(){
     data = $(this).attr('id').replace('star_','').split('_');
     product_id = data[0];
     rating_value = data[1];

     image = 'star-voted-';
     for(var i=1; i<=5; i++)
     {
       if(i <= rating_value){
         full_image = image+'on';
       }else{
         full_image = image+'off';
       }
       $('#star_'+product_id+"_"+i).attr('src', '/assets/'+full_image+'.png?t=1');
     }
   });

    $('body').delegate(".stars .star","mouseout", function() {
     product_id = $(this).attr('id').replace('star_','').split('_')[0];
     for(var i=1; i<=5; i++)
     {
       image = $('#star_'+product_id+'_'+i);
       image.attr('src','/assets/'+image.attr('name'));
     }
   });
   $('body').delegate('.trailer', 'click', function(){
     url = $(this).attr('href');
     jQuery.facebox(function() {
       $.ajax({
           url: url,
           dataType: 'html',
           type: 'GET',
           success: function(data) 
           { 
             set_page(url)
             var regex = new RegExp(".*/products/([0-9]*).*");
             res = regex.exec(url)
             send_event('Movie', 'ViewTrailer', res[1],'')

             jQuery.facebox(data); 
           }
         });
     });
     return false;
   });
   
});
function querySt(hu ,ji) {
  gy = hu.split("&");
  for (i=0;i<gy.length;i++) {
    ft = gy[i].split("=");
    if (ft[0] == ji) {
      return ft[1];
    }
  }
}
function set_page(url)
{
  
}
function send_event(arg1,arg2,arg3,arg4)
{
  
}