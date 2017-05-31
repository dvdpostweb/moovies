# == Schema Information
#
# Table name: samsung_codes
#
#  id           :integer          not null, primary key
#  code         :string(255)
#  customer_id  :integer
#  used_at      :datetime
#  created_at   :datetime
#  promotion    :string(255)      default("SMSPSH")
#  invoice      :binary(16777215)
#  validated_at :datetime
#  model        :string(40)
#

class SamsungCode < ActiveRecord::Base
  scope :available, where("customer_id is null")
  scope :unvalidated, where('validated_at is null')
end
