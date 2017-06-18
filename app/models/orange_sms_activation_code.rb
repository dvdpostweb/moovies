class OrangeSmsActivationCode < ActiveRecord::Base
  belongs_to :customer
  attr_accessible :phone_number, :sms_authentification_code
  validates :customers_id, presence: true
  validates :phone_number, presence: true
  validates :sms_authentification_code, presence: true
  validates_uniqueness_of :sms_authentification_code
end
