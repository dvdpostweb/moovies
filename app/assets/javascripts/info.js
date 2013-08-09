$(function() {
	$('#abo .link_adult').on('click', function(){
		$('#tab_adult').toggle()
	})
	$('#step2 #customer_customers_dob_3i').on('change', birth_change)
	function birth_change(event)
  {
  	if($('#step2 #customer_customers_dob_3i').val() || $('#step2 #customer_customers_dob_2i').val()  || $('#step2 #customer_customers_dob_1i').val() )
  	{
  	  
  	}
  	else
  	{
  	  age = calcul_age($('#day').attr('value')+'/'+$('#month').attr('value')+'/'+$('#year').attr('value'))
  	  if (age >= 18)
  	  {
  		  $('#check_birthday').addClass('step_input_ok').removeClass('step_input_error');
  		  $('#check_birthday').children('div').html(' ');
  	  }
  	  else
  	  {
  	    $('#check_birthday').addClass('step_input_error').removeClass('step_input_ok');
    		$('#check_birthday').children('div').html($('#error_minor').html());
  	  }
  	}
  }
  
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

