// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.datepicker
//= require jquery.ui.datepicker-fr
//= require facebox
//= require messages
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
});