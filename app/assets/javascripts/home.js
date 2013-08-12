$(function() {
  search_init2 = $('#public_newsletter_email').val();
  $('#home #public_newsletter_email').on('focus', function(){
    if($('#public_newsletter_email').val() == search_init2){
      $('#public_newsletter_email').val('');
    }
  });

  $('#home #public_newsletter_email').on('blur', function(){
    if($('#public_newsletter_email').val() == ''){
      $('#public_newsletter_email').val(search_init2);
    }
  });
  $('#home #new_public_newsletter').on('submit', function(){
    if($('#public_newsletter_email').val() == search_init2)
    {
      return false
    }
  })
});