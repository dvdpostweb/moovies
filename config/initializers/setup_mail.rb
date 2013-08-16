ActionMailer::Base.smtp_settings = {  
  :address              => "smtp-auth.Register.be", 
  :port                 => 1025,
  :domain               => "plush.be",
  :authentication       => "login",
  :user_name            => "info@plush.be",
  :password             => "fireball18",
  :enable_starttls_auto => true
}
ActionMailer::Base.default :from => 'info@plush.be'
