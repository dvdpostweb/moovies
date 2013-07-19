class SubscriptionPaymentMethod < ActiveRecord::Base
  self.table_name = :customers_abo_payment_method
  self.primary_key = :customers_abo_payment_method_id

  alias_attribute :name, :customers_abo_payment_method_name
end
