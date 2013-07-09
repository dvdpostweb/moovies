class TokensTrailer < ActiveRecord::Base
  scope :available, lambda {where('active = ? and expire_at > ?', 1, Time.now)}
  
end