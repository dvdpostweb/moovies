$(function() {
  $('#payment_methods').on('submit', function(){
    if($('input[name=brand]:checked', '#payment_methods').val() == undefined)
    {
      alert($('#alert_cc').html())
      return false
    }
  })
})