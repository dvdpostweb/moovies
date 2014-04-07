ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
  :access_key_id     => 'AKIAI53MSJVZ7SH6VGCQ',
  :secret_access_key => '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',
  :server => "email-smtp.eu-west-1.amazonaws.com",
  :port => 465