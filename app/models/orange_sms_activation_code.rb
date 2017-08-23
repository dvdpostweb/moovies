# == Schema Information
#
# Table name: orange_sms_activation_codes
#
#  id                        :integer          not null, primary key
#  customers_id              :string(255)
#  phone_number              :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  sms_authentification_code :string(255)
#

class OrangeSmsActivationCode < ActiveRecord::Base
  before_create :generate_token
  belongs_to :customer
  attr_accessible :phone_number, :sms_authentification_code
  validates :customers_id, presence: true
  validates :phone_number, presence: true
  validates :sms_authentification_code, presence: true
  validates_uniqueness_of :sms_authentification_code

  private

  def generate_token
    self.sms_authentification_code = loop do
      random_token = 4.times.map{rand(10)}.join
      break random_token unless OrangeSmsActivationCode.exists?(sms_authentification_code: random_token)
    end
  end

end
