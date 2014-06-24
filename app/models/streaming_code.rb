class StreamingCode < ActiveRecord::Base
  scope :available, lambda { where('(expiration_at > ? or expiration_at is null) and (used_at > ? or used_at is null)', Time.now.localtime.to_s(:db), 4.hours.ago.localtime.to_s(:db))}
  scope :email, where('email is null')
  
  scope :by_name, lambda {|name| where(:name => name)}
  def available?
    (used_at.nil? || used_at >= 4.hours.ago.localtime) && (expiration_at.nil? || expiration_at >= Date.today)
  end
end