class Emailer < ActionMailer::Base
   def send(recipient, subject, message, sent_on = Time.now)
      @subject = subject
      @recipients = recipient
      @from = 'info@plush.be'
      @sent_on = sent_on
      @headers = {}
   end
end
