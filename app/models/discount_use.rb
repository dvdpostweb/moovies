# == Schema Information
#
# Table name: discount_use
#
#  discount_use_id    :integer          not null, primary key
#  discount_code_id   :integer          default(0), not null
#  discount_use_date  :datetime         not null
#  customers_id       :integer          default(0), not null
#  bypass_discountuse :integer
#

class DiscountUse < ActiveRecord::Base

  self.table_name = :discount_use
  self.primary_key = :discount_use_id

  alias_attribute :created_at, :discount_use_date
  alias_attribute :customer_id, :customers_id
  scope :use, lambda { |months| where(:discount_use_date => months.months.ago..Time.now.end_of_day) }
end
