ActionMailer::Base.smtp_settings = {  
  :address              => "mail.dvdpost.local",  
  :port                 => 25,  
  :domain               => "dvdpost.be",  
  :authentication       => "none",  
  :enable_starttls_auto => false  
}
ActionMailer::Base.default_url_options[:host] = "localhost:3000"  
ActionMailer::Base.default :from => 'info@dvdpost.be'