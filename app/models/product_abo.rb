# == Schema Information
#
# Table name: products_abo
#
#  products_id   :integer          default(0), not null, primary key
#  name          :string(255)
#  description   :string(255)
#  packages_ids  :string(50)
#  price         :decimal(5, 2)
#  package_count :integer
#  tvod_credits  :integer          default(0)
#

class ProductAbo < ActiveRecord::Base
  self.table_name = :products_abo
  self.primary_key = :products_id
end
