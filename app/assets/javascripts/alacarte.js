$(document).ready(function(){
    if (gon.alacarte == "alacarte_not_signed_in" || gon.abo == "abo_not_signed_in") {
    	$('#alacarte-2-films').on('click', function(e) {
    		$(".ns-box").hide();
    		$(".list-default-2-films").hide();
	    	$("#alacarte-button-default").hide();
	    	$("#default").hide();
	    	$(".ALBTN").hide();
        $("#default-3-1").hide();
	    	$("#default-3-2").hide();
	    	$("#default-3-3").hide();
	    	$("#default-3-4").hide();
	    	$("#default-3-5").hide();
	    	$("#green-3-1").show();
	    	$("#green-3-2").show();
	    	$("#green-3-3").show();
        $("#green-3-4").show();
        $("#red-3-5").show();
        $("#green-7-1").hide();
	    	$("#green-7-2").hide();
	    	$("#green-7-3").hide();
        $("#green-7-4").hide();
        $("#red-7-5").hide()
        $("#default-7-1").show();
	    	$("#default-7-2").show();
	    	$("#default-7-3").show();
	    	$("#default-7-4").show();
	    	$("#default-7-5").show();
        $("#green-11-1").hide();
	    	$("#green-11-2").hide();
	    	$("#green-11-3").hide();
        $("#green-11-4").hide();
        $("#red-11-5").hide()
        $("#default-11-1").show();
	    	$("#default-11-2").show();
	    	$("#default-11-3").show();
	    	$("#default-11-4").show();
	    	$("#default-11-5").show();
	      $(this).addClass("film-box-darker");
	      $("#3euro").addClass("green-text");
	      $("#3euroil").addClass("green-text");
	      $('#alacarte-4-films').removeClass("film-box-darker");
	      $('#alacarte-6-films').removeClass("film-box-darker");
	      $('#7euro').removeClass("green-text");
	      $('#11euro').removeClass("green-text");
	      $('#7euroil').removeClass("green-text");
	      $('#11euroil').removeClass("green-text")
	      $('body').animate({
          scrollTop: eval($('#' + $(this).attr('target')).offset().top - 70)
		    }, 1000);
		    if (gon.locale === "fr") {
		    	$("#alacarte-button-CF4FILMS-FR").show();
		    }
		    if (gon.locale === "nl") {
		    	$("#alacarte-button-CF4FILMS-NL").show();
		    }
		    if (gon.locale === "en") {
		    	$("#alacarte-button-CF4FILMS-EN").show();
		    }
	    });
	    $('#alacarte-4-films').on('click', function(e) {
	    	$(".ns-box").hide();
	    	$(".list-default-4-films").hide();
	    	$("#alacarte-button-default").hide();
	    	$(".ALBTN").hide();
	      $("#default-7-1").hide();
	    	$("#default-7-2").hide();
	    	$("#default-7-3").hide();
	    	$("#default-7-4").hide();
	    	$("#default-7-5").hide();
	    	$("#green-7-1").show();
	    	$("#green-7-2").show();
	    	$("#green-7-3").show();
        $("#green-7-4").show();
        $("#red-7-5").show();
        $("#green-3-1").hide();
	    	$("#green-3-2").hide();
	    	$("#green-3-3").hide();
        $("#green-3-4").hide();
        $("#red-3-5").hide()
        $("#default-3-1").show();
	    	$("#default-3-2").show();
	    	$("#default-3-3").show();
	    	$("#default-3-4").show();
	    	$("#default-3-5").show();
        $("#green-11-1").hide();
	    	$("#green-11-2").hide();
	    	$("#green-11-3").hide();
        $("#green-11-4").hide();
        $("#red-11-5").hide()
        $("#default-11-1").show();
	    	$("#default-11-2").show();
	    	$("#default-11-3").show();
	    	$("#default-11-4").show();
	    	$("#default-11-5").show();
	      $(this).addClass("film-box-darker");
	      $("#7euro").addClass("green-text");
	      $("#7euroil").addClass("green-text");
	      $('#alacarte-2-films').removeClass("film-box-darker");
	      $('#alacarte-6-films').removeClass("film-box-darker");
	      $('#3euro').removeClass("green-text");
	      $('#11euro').removeClass("green-text");
	      $('#3euroil').removeClass("green-text");
	      $('#11euroil').removeClass("green-text");
	      $('body').animate({
		        scrollTop: eval($('#' + $(this).attr('target')).offset().top - 70)
		    }, 1000);
		    if (gon.locale === "fr") {
		    	$("#alacarte-button-CF6FILMS-FR").show();
		    }
		    if (gon.locale === "nl") {
		    	$("#alacarte-button-CF6FILMS-NL").show();
		    }
		    if (gon.locale === "en") {
		    	$("#alacarte-button-CF6FILMS-EN").show();
		    }
	    });
	    $('#alacarte-6-films').on('click', function(e) {
	    	$(".ns-box").hide();
	    	$(".list-default-6-films").hide();
	    	$("#alacarte-button-default").hide();
	    	$(".ALBTN").hide();
        $("#default-11-1").hide();
	    	$("#default-11-2").hide();
	    	$("#default-11-3").hide();
	    	$("#default-11-4").hide();
	    	$("#default-11-5").hide();
	    	$("#green-11-1").show();
	    	$("#green-11-2").show();
	    	$("#green-11-3").show();
        $("#green-11-4").show();
        $("#red-11-5").show();
        $("#green-3-1").hide();
	    	$("#green-3-2").hide();
	    	$("#green-3-3").hide();
        $("#green-3-4").hide();
        $("#red-3-5").hide();
        $("#default-3-1").show();
	    	$("#default-3-2").show();
	    	$("#default-3-3").show();
	    	$("#default-3-4").show();
	    	$("#default-3-5").show();
        $("#green-7-1").hide();
	    	$("#green-7-2").hide();
	    	$("#green-7-3").hide();
        $("#green-7-4").hide();
        $("#red-7-5").hide();
        $("#default-7-1").show();
	    	$("#default-7-2").show();
	    	$("#default-7-3").show();
	    	$("#default-7-4").show();
	    	$("#default-7-5").show();
	      $(this).addClass("film-box-darker");
	      $("#11euro").addClass("green-text");
	      $("#11euroil").addClass("green-text");
	      $('#alacarte-2-films').removeClass("film-box-darker");
	      $('#alacarte-4-films').removeClass("film-box-darker");
	      $('#3euro').removeClass("green-text");
	      $('#7euro').removeClass("green-text");
	      $('#3euroil').removeClass("green-text");
	      $('#7euroil').removeClass("green-text");
	      $('body').animate({
		      scrollTop: eval($('#' + $(this).attr('target')).offset().top - 70)
		    }, 1000);
		    if (gon.locale === "fr") {
		    	$("#alacarte-button-CF8FILMS-FR").show();
		    }
		    if (gon.locale === "nl") {
		    	$("#alacarte-button-CF8FILMS-NL").show();
		    }
		    if (gon.locale === "en") {
		    	$("#alacarte-button-CF8FILMS-EN").show();
		    }
	    });
	    var bttn = document.getElementById( 'alacarte-button-default' );
		  bttn.addEventListener( 'click', function() {
		  	setTimeout( function() {
		  		var notification = new NotificationFx({
		  			message : '<h1 id="alacarte-error-msg">Please select the package</h1>',
		  			layout : 'bar',
		  			effect : 'slidetop',
		  			type : 'notice'
		  		});
		  		notification.show();
		  	}, 1200 );
		  	$('body').animate({
		          scrollTop: eval($('#' + $(this).attr('target')).offset().top - 70)
		      }, 1000);
		  });
    } else if (gon.alacarte == "alacarte" || gon.abo == "abo") {
      $('#alacarte-2-films').on('click', function(e) {
    		$(".ns-box").hide();
    		$(".list-default-2-films").hide();
	    	$("#alacarte-button-default").hide();
	    	$("#default").hide();
	    	$(".ALBTN").hide();
        $("#default-3-1").hide();
	    	$("#default-3-2").hide();
	    	$("#default-3-3").hide();
	    	$("#default-3-4").hide();
	    	$("#default-3-5").hide();
	    	$("#green-3-1").show();
	    	$("#green-3-2").show();
	    	$("#green-3-3").show();
        $("#green-3-4").show();
        $("#red-3-5").show();
        $("#green-7-1").hide();
	    	$("#green-7-2").hide();
	    	$("#green-7-3").hide();
        $("#green-7-4").hide();
        $("#red-7-5").hide()
        $("#default-7-1").show();
	    	$("#default-7-2").show();
	    	$("#default-7-3").show();
	    	$("#default-7-4").show();
	    	$("#default-7-5").show();
        $("#green-11-1").hide();
	    	$("#green-11-2").hide();
	    	$("#green-11-3").hide();
        $("#green-11-4").hide();
        $("#red-11-5").hide()
        $("#default-11-1").show();
	    	$("#default-11-2").show();
	    	$("#default-11-3").show();
	    	$("#default-11-4").show();
	    	$("#default-11-5").show();
	      $(this).addClass("film-box-darker");
	      $("#3euro").addClass("green-text");
	      $("#3euroil").addClass("green-text");
	      $('#alacarte-4-films').removeClass("film-box-darker");
	      $('#alacarte-6-films').removeClass("film-box-darker");
	      $('#7euro').removeClass("green-text");
	      $('#11euro').removeClass("green-text");
	      $('#7euroil').removeClass("green-text");
	      $('#11euroil').removeClass("green-text")
	      $('body').animate({
          scrollTop: eval($('#' + $(this).attr('target')).offset().top - 70)
		    }, 1000);
		    if (gon.locale === "fr") {
		    	$("#alacarte-button-CF4FILMS-FR").show();
		    }
		    if (gon.locale === "nl") {
		    	$("#alacarte-button-CF4FILMS-NL").show();
		    }
		    if (gon.locale === "en") {
		    	$("#alacarte-button-CF4FILMS-EN").show();
		    }
	    });
	    $('#alacarte-4-films').on('click', function(e) {
	    	$(".ns-box").hide();
	    	$(".list-default-4-films").hide();
	    	$("#alacarte-button-default").hide();
	    	$(".ALBTN").hide();
	      $("#default-7-1").hide();
	    	$("#default-7-2").hide();
	    	$("#default-7-3").hide();
	    	$("#default-7-4").hide();
	    	$("#default-7-5").hide();
	    	$("#green-7-1").show();
	    	$("#green-7-2").show();
	    	$("#green-7-3").show();
        $("#green-7-4").show();
        $("#red-7-5").show();
        $("#green-3-1").hide();
	    	$("#green-3-2").hide();
	    	$("#green-3-3").hide();
        $("#green-3-4").hide();
        $("#red-3-5").hide()
        $("#default-3-1").show();
	    	$("#default-3-2").show();
	    	$("#default-3-3").show();
	    	$("#default-3-4").show();
	    	$("#default-3-5").show();
        $("#green-11-1").hide();
	    	$("#green-11-2").hide();
	    	$("#green-11-3").hide();
        $("#green-11-4").hide();
        $("#red-11-5").hide()
        $("#default-11-1").show();
	    	$("#default-11-2").show();
	    	$("#default-11-3").show();
	    	$("#default-11-4").show();
	    	$("#default-11-5").show();
	      $(this).addClass("film-box-darker");
	      $("#7euro").addClass("green-text");
	      $("#7euroil").addClass("green-text");
	      $('#alacarte-2-films').removeClass("film-box-darker");
	      $('#alacarte-6-films').removeClass("film-box-darker");
	      $('#3euro').removeClass("green-text");
	      $('#11euro').removeClass("green-text");
	      $('#3euroil').removeClass("green-text");
	      $('#11euroil').removeClass("green-text");
	      $('body').animate({
		        scrollTop: eval($('#' + $(this).attr('target')).offset().top - 70)
		    }, 1000);
		    if (gon.locale === "fr") {
		    	$("#alacarte-button-CF6FILMS-FR").show();
		    }
		    if (gon.locale === "nl") {
		    	$("#alacarte-button-CF6FILMS-NL").show();
		    }
		    if (gon.locale === "en") {
		    	$("#alacarte-button-CF6FILMS-EN").show();
		    }
	    });
	    $('#alacarte-6-films').on('click', function(e) {
	    	$(".ns-box").hide();
	    	$(".list-default-6-films").hide();
	    	$("#alacarte-button-default").hide();
	    	$(".ALBTN").hide();
        $("#default-11-1").hide();
	    	$("#default-11-2").hide();
	    	$("#default-11-3").hide();
	    	$("#default-11-4").hide();
	    	$("#default-11-5").hide();
	    	$("#green-11-1").show();
	    	$("#green-11-2").show();
	    	$("#green-11-3").show();
        $("#green-11-4").show();
        $("#red-11-5").show();
        $("#green-3-1").hide();
	    	$("#green-3-2").hide();
	    	$("#green-3-3").hide();
        $("#green-3-4").hide();
        $("#red-3-5").hide();
        $("#default-3-1").show();
	    	$("#default-3-2").show();
	    	$("#default-3-3").show();
	    	$("#default-3-4").show();
	    	$("#default-3-5").show();
        $("#green-7-1").hide();
	    	$("#green-7-2").hide();
	    	$("#green-7-3").hide();
        $("#green-7-4").hide();
        $("#red-7-5").hide();
        $("#default-7-1").show();
	    	$("#default-7-2").show();
	    	$("#default-7-3").show();
	    	$("#default-7-4").show();
	    	$("#default-7-5").show();
	      $(this).addClass("film-box-darker");
	      $("#11euro").addClass("green-text");
	      $("#11euroil").addClass("green-text");
	      $('#alacarte-2-films').removeClass("film-box-darker");
	      $('#alacarte-4-films').removeClass("film-box-darker");
	      $('#3euro').removeClass("green-text");
	      $('#7euro').removeClass("green-text");
	      $('#3euroil').removeClass("green-text");
	      $('#7euroil').removeClass("green-text");
	      $('body').animate({
		      scrollTop: eval($('#' + $(this).attr('target')).offset().top - 70)
		    }, 1000);
		    if (gon.locale === "fr") {
		    	$("#alacarte-button-CF8FILMS-FR").show();
		    }
		    if (gon.locale === "nl") {
		    	$("#alacarte-button-CF8FILMS-NL").show();
		    }
		    if (gon.locale === "en") {
		    	$("#alacarte-button-CF8FILMS-EN").show();
		    }
	    });
	    var bttn = document.getElementById( 'alacarte-button-default' );
		  bttn.addEventListener( 'click', function() {
		  	setTimeout( function() {
		  		var notification = new NotificationFx({
		  			message : '<h1 id="alacarte-error-msg">Please select the package</h1>',
		  			layout : 'bar',
		  			effect : 'slidetop',
		  			type : 'notice'
		  		});
		  		notification.show();
		  	}, 1200 );
		  	$('body').animate({
		          scrollTop: eval($('#' + $(this).attr('target')).offset().top - 70)
		      }, 1000);
		  });
      $("#alacarte-button-CF4FILMS-FR, #alacarte-button-CF4FILMS-NL, #alacarte-button-CF4FILMS-EN").each(function() {
        $(this).click(function() {
          $.ajax({
            method: 'POST',
            url: '/api/v1/activate_new_plan',
            data: {
              'customer_email': gon.current_customer.email,
              'discount_code': "2FILMS"
            },
            dataType: 'json',
            success: function (response) {
              if (1 === response.status) {
                window.location.href = "/" + gon.locale + "/steps/step3"
              } else if (2 === response.status) {
              	$.toast({
				    heading: infoMessage(),
				    text: textMessage(),
				    icon: 'info',
				    loader: true,
				    loaderBg: '#9EC600'
				})
              }
            },
            error: function (response) {
              console.log('CHECKED AJAX ERROR!!!');
            }
          });
        });
      });
      $("#alacarte-button-CF6FILMS-FR, #alacarte-button-CF6FILMS-NL, #alacarte-button-CF6FILMS-EN").each(function() {
        $(this).click(function() {
          $.ajax({
            method: 'POST',
            url: '/api/v1/activate_new_plan',
            data: {
              'customer_email': gon.current_customer.email,
              'discount_code': "4FILMS"
            },
            dataType: 'json',
            success: function (response) {
              if (1 === response.status) {
                window.location.href = "/" + gon.locale + "/steps/step3"
              } else if (2 === response.status) {
              	$.toast({
				    heading: infoMessage(),
				    text: textMessage(),
				    icon: 'info',
				    loader: true,        
				    loaderBg: '#9EC600'
				})
              }
            },
            error: function (response) {
              console.log('CHECKED AJAX ERROR!!!');
            }
          });
        });
      });
      $("#alacarte-button-CF8FILMS-FR, #alacarte-button-CF8FILMS-NL, #alacarte-button-CF8FILMS-EN").each(function() {
        $(this).click(function() {
          $.ajax({
            method: 'POST',
            url: '/api/v1/activate_new_plan',
            data: {
              'customer_email': gon.current_customer.email,
              'discount_code': "6FILMS"
            },
            dataType: 'json',
            success: function (response) {
              if (1 === response.status) {
                window.location.href = "/" + gon.locale + "/steps/step3"
              } else if (2 === response.status) {
              	$.toast({
				    heading: infoMessage(),
				    text: textMessage(),
				    icon: 'info',
				    loader: true,       
				    loaderBg: '#9EC600' 
				})
              }
            },
            error: function (response) {
              console.log('CHECKED AJAX ERROR!!!');
            }
          });
        });
      });
    } else if (gon.unlimited == "unlimited") {
      $("#svod").click(function() {
        $.ajax({
          method: 'POST',
          url: '/api/v1/activate_new_plan',
          data: {
            'customer_email': gon.current_customer.email,
            'discount_code': "SVOD"
          },
          dataType: 'json',
          success: function (response) {
            if (1 === response.status) {
              window.location.href = "/" + gon.locale + "/steps/step3"
            } else if (2 === response.status) {
              	$.toast({
				    heading: infoMessage(),
				    text: textMessage(),
				    icon: 'info',
				    loader: true, 
				    loaderBg: '#9EC600'
				})
            }
          },
          error: function (response) {
            console.log('CHECKED AJAX ERROR!!!');
          }
        });
      });
    } else if (gon.adult == "adult") {
      $("#svod_adult").click(function() {
        $.ajax({
          method: 'POST',
          url: '/api/v1/activate_new_plan',
          data: {
            'customer_email': gon.current_customer.email,
            'discount_code': "SVOD_ADULT"
          },
          dataType: 'json',
          success: function (response) {
            if (1 === response.status) {
              window.location.href = "/" + gon.locale + "/steps/step3"
            } else if (2 === response.status) {
              	$.toast({
				    heading: infoMessage(),
				    text: textMessage(),
				    icon: 'info',
				    loader: true,        
				    loaderBg: '#9EC600'
				})
            }
          },
          error: function (response) {
            console.log('CHECKED AJAX ERROR!!!');
          }
        });
      });
    } else if (gon.freetrial == "freetrial") {
    	$('#alacarte-2-films').on('click', function(e) {
    		$(".ns-box").hide();
    		$(".list-default-2-films").hide();
	    	$("#alacarte-button-default").hide();
	    	$("#default").hide();
	    	$(".ALBTN").hide();
        $("#default-3-1").hide();
	    	$("#default-3-2").hide();
	    	$("#default-3-3").hide();
	    	$("#default-3-4").hide();
	    	$("#default-3-5").hide();
	    	$("#green-3-1").show();
	    	$("#green-3-2").show();
	    	$("#green-3-3").show();
        $("#green-3-4").show();
        $("#red-3-5").show();
        $("#green-7-1").hide();
	    	$("#green-7-2").hide();
	    	$("#green-7-3").hide();
        $("#green-7-4").hide();
        $("#red-7-5").hide()
        $("#default-7-1").show();
	    	$("#default-7-2").show();
	    	$("#default-7-3").show();
	    	$("#default-7-4").show();
	    	$("#default-7-5").show();
        $("#green-11-1").hide();
	    	$("#green-11-2").hide();
	    	$("#green-11-3").hide();
        $("#green-11-4").hide();
        $("#red-11-5").hide()
        $("#default-11-1").show();
	    	$("#default-11-2").show();
	    	$("#default-11-3").show();
	    	$("#default-11-4").show();
	    	$("#default-11-5").show();
	      $(this).addClass("film-box-darker");
	      $("#3euro").addClass("green-text");
	      $("#3euroil").addClass("green-text");
	      $('#alacarte-4-films').removeClass("film-box-darker");
	      $('#alacarte-6-films').removeClass("film-box-darker");
	      $('#7euro').removeClass("green-text");
	      $('#11euro').removeClass("green-text");
	      $('#7euroil').removeClass("green-text");
	      $('#11euroil').removeClass("green-text")
	      $('body').animate({
          scrollTop: eval($('#' + $(this).attr('target')).offset().top - 70)
		    }, 1000);
		    if (gon.locale === "fr") {
		    	$("#alacarte-button-CF4FILMS-FR").show();
		    }
		    if (gon.locale === "nl") {
		    	$("#alacarte-button-CF4FILMS-NL").show();
		    }
		    if (gon.locale === "en") {
		    	$("#alacarte-button-CF4FILMS-EN").show();
		    }
	    });
	    $('#alacarte-4-films').on('click', function(e) {
	    	$(".ns-box").hide();
	    	$(".list-default-4-films").hide();
	    	$("#alacarte-button-default").hide();
	    	$(".ALBTN").hide();
	      $("#default-7-1").hide();
	    	$("#default-7-2").hide();
	    	$("#default-7-3").hide();
	    	$("#default-7-4").hide();
	    	$("#default-7-5").hide();
	    	$("#green-7-1").show();
	    	$("#green-7-2").show();
	    	$("#green-7-3").show();
        $("#green-7-4").show();
        $("#red-7-5").show();
        $("#green-3-1").hide();
	    	$("#green-3-2").hide();
	    	$("#green-3-3").hide();
        $("#green-3-4").hide();
        $("#red-3-5").hide()
        $("#default-3-1").show();
	    	$("#default-3-2").show();
	    	$("#default-3-3").show();
	    	$("#default-3-4").show();
	    	$("#default-3-5").show();
        $("#green-11-1").hide();
	    	$("#green-11-2").hide();
	    	$("#green-11-3").hide();
        $("#green-11-4").hide();
        $("#red-11-5").hide()
        $("#default-11-1").show();
	    	$("#default-11-2").show();
	    	$("#default-11-3").show();
	    	$("#default-11-4").show();
	    	$("#default-11-5").show();
	      $(this).addClass("film-box-darker");
	      $("#7euro").addClass("green-text");
	      $("#7euroil").addClass("green-text");
	      $('#alacarte-2-films').removeClass("film-box-darker");
	      $('#alacarte-6-films').removeClass("film-box-darker");
	      $('#3euro').removeClass("green-text");
	      $('#11euro').removeClass("green-text");
	      $('#3euroil').removeClass("green-text");
	      $('#11euroil').removeClass("green-text");
	      $('body').animate({
		        scrollTop: eval($('#' + $(this).attr('target')).offset().top - 70)
		    }, 1000);
		    if (gon.locale === "fr") {
		    	$("#alacarte-button-CF6FILMS-FR").show();
		    }
		    if (gon.locale === "nl") {
		    	$("#alacarte-button-CF6FILMS-NL").show();
		    }
		    if (gon.locale === "en") {
		    	$("#alacarte-button-CF6FILMS-EN").show();
		    }
	    });
	    $('#alacarte-6-films').on('click', function(e) {
	    	$(".ns-box").hide();
	    	$(".list-default-6-films").hide();
	    	$("#alacarte-button-default").hide();
	    	$(".ALBTN").hide();
        $("#default-11-1").hide();
	    	$("#default-11-2").hide();
	    	$("#default-11-3").hide();
	    	$("#default-11-4").hide();
	    	$("#default-11-5").hide();
	    	$("#green-11-1").show();
	    	$("#green-11-2").show();
	    	$("#green-11-3").show();
        $("#green-11-4").show();
        $("#red-11-5").show();
        $("#green-3-1").hide();
	    	$("#green-3-2").hide();
	    	$("#green-3-3").hide();
        $("#green-3-4").hide();
        $("#red-3-5").hide();
        $("#default-3-1").show();
	    	$("#default-3-2").show();
	    	$("#default-3-3").show();
	    	$("#default-3-4").show();
	    	$("#default-3-5").show();
        $("#green-7-1").hide();
	    	$("#green-7-2").hide();
	    	$("#green-7-3").hide();
        $("#green-7-4").hide();
        $("#red-7-5").hide();
        $("#default-7-1").show();
	    	$("#default-7-2").show();
	    	$("#default-7-3").show();
	    	$("#default-7-4").show();
	    	$("#default-7-5").show();
	      $(this).addClass("film-box-darker");
	      $("#11euro").addClass("green-text");
	      $("#11euroil").addClass("green-text");
	      $('#alacarte-2-films').removeClass("film-box-darker");
	      $('#alacarte-4-films').removeClass("film-box-darker");
	      $('#3euro').removeClass("green-text");
	      $('#7euro').removeClass("green-text");
	      $('#3euroil').removeClass("green-text");
	      $('#7euroil').removeClass("green-text");
	      $('body').animate({
		      scrollTop: eval($('#' + $(this).attr('target')).offset().top - 70)
		    }, 1000);
		    if (gon.locale === "fr") {
		    	$("#alacarte-button-CF8FILMS-FR").show();
		    }
		    if (gon.locale === "nl") {
		    	$("#alacarte-button-CF8FILMS-NL").show();
		    }
		    if (gon.locale === "en") {
		    	$("#alacarte-button-CF8FILMS-EN").show();
		    }
	    });
	    var bttn = document.getElementById( 'alacarte-button-default' );
		  bttn.addEventListener( 'click', function() {
		  	setTimeout( function() {
		  		var notification = new NotificationFx({
		  			message : '<h1 id="alacarte-error-msg">Please select the package</h1>',
		  			layout : 'bar',
		  			effect : 'slidetop',
		  			type : 'notice'
		  		});
		  		notification.show();
		  	}, 1200 );
		  	$('body').animate({
		          scrollTop: eval($('#' + $(this).attr('target')).offset().top - 70)
		      }, 1000);
		  });
    }
});

function infoMessage() {
if (gon.locale == "fr") {
  return "INFO"
} else if (gon.locale == "nl") {
  return "INFO"
} else if (gon.locale == "en") {
  return "INFO"
}
}

function textMessage() {
if (gon.locale == "fr") {
  return "Vous ne pouvez pas bénéficier de cette promotion"
} else if (gon.locale == "nl") {
  return "Je kunt niet profiteren van deze promotie"
} else if (gon.locale == "en") {
  return "You can not benefit from this promotion"
}
}
