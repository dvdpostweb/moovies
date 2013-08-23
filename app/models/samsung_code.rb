class SamsungCode < ActiveRecord::Base
  scope :available, where("customer_id is null")
end