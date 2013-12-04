class DiscountUse < ActiveRecord::Base

  self.table_name = :discount_use
  self.primary_key = :discount_use_id

  alias_attribute :created_at, :discount_use_date
  alias_attribute :customer_id, :customers_id
  scope :use, lambda {|months| where(:discount_use_date => months.months.ago..Time.now.end_of_day)}
end
