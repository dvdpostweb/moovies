class SamsungCode < ActiveRecord::Base
  scope :available, where("customer_id is null")
  scope :unvalidated, where('validated_at is null')
end