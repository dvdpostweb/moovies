class StreamingCode < ActiveRecord::Base
  scope :available, lambda { where('(expiration_at > ? or expiration_at is null) and used_at is null', Time.now.to_s(:db))}
  scope :email, where('email is null')
  
  scope :by_name, lambda {|name| where(:name => name)}
  def available?
    used_at.nil? && (expiration_at.nil? || expiration_at >= Date.today)
  end
end