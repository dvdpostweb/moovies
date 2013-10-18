//= require jquery

$(function() {
  $('#code3, #code4').on('focus', function(){
    if($(this).val() == $('#default').html()){
      $(this).val('');
    }
  });

  $('#code3, #code4').on('blur', function(){
    if($(this).val() == ''){
      $(this).val($('#default').html());
    }
  });
  $('#form_step, #form_step2').on('submit', function(){
    if($(this).children('.inputs_promo_code').val() == '' || $(this).children('.inputs_promo_code').val() == $('#default').html()){
      return false
    }
		else
		{
			id = $(this).attr('id')
			if(id == 'form_step')
			{
				id_mark = '#mark'
			}
			else
			{
				id_mark = '#mark2'
			}
			if(!$(id_mark).is(':checked'))
			{
				alert($('#text_error_conditions').html())
		    return false
			}
		}
    
  })
  $('#new_customer, #new_customer2').on('submit', function(){
    
			id = $(this).attr('id')
			if(id == 'new_customer')
			{
				id_mark = '#mark'
			}
			else
			{
				id_mark = '#mark2'
			}
			if(!$(id_mark).is(':checked'))
			{
				alert($('#text_error_conditions').html())
		    return false
			}
	})	
  
})