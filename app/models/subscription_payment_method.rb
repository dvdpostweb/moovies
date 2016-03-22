# == Schema Information
#
# Table name: customers_abo_payment_method
#
#  customers_abo_payment_method_id   :integer          default(0), not null, primary key
#  customers_abo_payment_method_name :string(50)       default(""), not null
#

class SubscriptionPaymentMethod < ActiveRecord::Base
  self.table_name = :customers_abo_payment_method
  self.primary_key = :customers_abo_payment_method_id

  alias_attribute :name, :customers_abo_payment_method_name
end
