class Emailer < ActionMailer::Base
   def send(recipient, subject, message, sent_on = Time.now)
      @subject = subject
      @recipients = recipient
      @from = 'info@plush.be'
      @sent_on = sent_on
      @headers = {}
   end
   
   def welcome_email(user, subject, content, test)
       @user = user
       @email = test ? 'gs@dvdpost.be' : user.email
       @content = content
       mail(:to => @email, :subject => subject)
     end
end
