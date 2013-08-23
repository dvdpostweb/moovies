//= require jquery

$(function() {
  $('#code3, #code4').on('focus', function(){
    console.log($(this).val())
    console.log($('#default').html())
    console.log($(this).val() == $('#default').html())
    if($(this).val() == $('#default').html()){
      $(this).val('');
    }
  });

  $('#code3, #code4').on('blur', function(){
    if($(this).val() == ''){
      $(this).val($('#default').html());
    }
  });
  $('#code3, #code4').on('submit', function(){
    if($(this).val() == '' || $(this).val() == $('#default').html()){
      return false
    }
    
  })
})