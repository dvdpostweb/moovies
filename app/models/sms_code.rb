class SmsCode < ActiveRecord::Base
  attr_accessible :code

  before_create :create_unique_code

  def create_unique_code
    begin
      self.code = SecureRandom.hex(5)
    end while self.class.exists?(:code => code)
  end

end
