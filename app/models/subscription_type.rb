class SubscriptionType < ActiveRecord::Base
  self.table_name = :products_abo
  self.primary_key = :products_id

  belongs_to :product, :foreign_key => :products_id
end
