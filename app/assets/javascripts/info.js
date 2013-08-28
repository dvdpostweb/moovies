$(function() {
  $('#form_step3').on('submit', function(){
    if($('input[name=brand]:checked', '#form_step3').val() == undefined)
    {
      alert($('#alert_cc').html())
      return false
    }
  })
  
	$('#abo .link_adult').on('click', function(){
		$('#tab_adult').toggle()
	})
	$('#step2 #customer_customers_dob_3i').on('change', birth_change)
	$('#step2 #customer_customers_dob_2i').on('change', birth_change)
	$('#step2 #customer_customers_dob_1i').on('change', birth_change)
	$('#step2 #edit_customer').on('submit', function (){
	  if(!$('#condition').is(':checked'))
	  {
	    alert($('#promotions_alert').html())
	    return false
	  }
	})
	function birth_change(event)
  {
  	if($('#step2 #customer_customers_dob_3i').val() == '' || $('#step2 #customer_customers_dob_2i').val() == '' || $('#step2 #customer_customers_dob_1i').val()== '' )
  	{
  	  $(this).parent().children('.message').html($('#date_invalid').html())
  	  $(this).parent().addClass('field_with_errors2')
  	}
  	else
  	{
  	  date = $('#step2 #customer_customers_dob_3i').val()+'/'+$('#step2 #customer_customers_dob_2i').val()+'/'+$('#step2 #customer_customers_dob_1i').val()
  	  age = calcul_age(date)
  	  
  	  if (age >= 18)
  	  {
  		  $(this).parent().children('.message').html('')
  		  $(this).parent().removeClass('field_with_errors2')
  	  }
  	  else
  	  {
  	    $(this).parent().children('.message').html($('#date_kid').html())
  	    $(this).parent().addClass('field_with_errors2')
  	  }
  	}
  }
  $('#vod #vod_more').on('click', function(){
    $('#more_info_android').toggle()
    return false
  })
});

function calcul_age(date_naissance){
	
	
	var elem_n = date_naissance.split('/');
		jour_n = elem_n[0];
		mois_n = elem_n[1];
		annee_n = elem_n[2];
	
	var date_day = new Date();
		jour_day = date_day.getDate();
		mois_day = date_day.getMonth()+1;
		annee_day = date_day.getFullYear();
	
	//calcul age
	var ans; var mois; var age="";
	
	if(mois_day >= mois_n){
		ans =  annee_day - annee_n;
		mois= mois_day - mois_n;
	}else{
		ans =  (annee_day - annee_n) -1;
		mois= mois_day +( 12 - mois_n);
	}
	if(jour_day < jour_n){	
		mois= mois -1;
		if(mois_day < mois_n){
		ans =  ans -1;
		}	
	}
	
	if(ans >0 && ans <=1) age += ans+' an ';
	if(ans >1) age += ans+' ans ';
	if(mois >0) age +=mois+' mois ';
	 // on affiche le résultat
	return ans ;
}

