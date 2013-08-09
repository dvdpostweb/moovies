class Payment < ActiveRecord::Base
  self.table_name = :payment

  alias_attribute :customer_id,    :customers_id
  alias_attribute :created_at,    :date_added
  
  scope :recovery, where(:payment_status => [13,14,15,16,17,10,11,12,19,20,21,22])
end
