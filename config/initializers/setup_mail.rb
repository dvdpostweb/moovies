ActionMailer::Base.smtp_settings = {  
  :openssl_verify_mode  => OpenSSL::SSL::VERIFY_NONE,
  :address              => "email-smtp.eu-west-1.amazonaws.com", 
  :port                 => 465,
  :domain               => "plush.be",
  :authentication       => "login",
  :user_name            => "AKIAICQS7KIVA5N62SKQ",
  :password             => "Au/ZyAC8yBAZGGSPdGDNEz00v2biQZPjUnxpd+qLl3Xn",
  :enable_starttls_auto => true
}
#ActionMailer::Base.smtp_settings = {  
#  :openssl_verify_mode  => OpenSSL::SSL::VERIFY_NONE,
#  :address              => "smtp-auth.Register.be", 
#  :port                 => 1025,
#  :domain               => "plush.be",
#  :authentication       => "login",
#  :user_name            => "info@plush.be",
#  :password             => "fireball18",
#  :enable_starttls_auto => true
#}
ActionMailer::Base.default :from => 'info@plush.be'
