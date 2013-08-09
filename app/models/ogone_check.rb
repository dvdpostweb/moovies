class OgoneCheck < ActiveRecord::Base
  self.table_name = :ogone_check
  
  alias_attribute :product_id, :products_id
  
  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :subscription_type, :foreign_key => :products_id
  belongs_to :product, :foreign_key => :products_id
  
end