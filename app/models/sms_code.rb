class SmsCode < ActiveRecord::Base
  attr_accessible :code, :phone_number

  #validates :code, presence: true
  validates :phone_number, presence: true
  validates_uniqueness_of :code

  before_create :create_unique_code

  def code=(val)
    self[:code] = val.upcase
  end

  def create_unique_code
    begin
      self.code = SecureRandom.hex(2)
    end while self.class.exists?(:code => code)
  end

end
