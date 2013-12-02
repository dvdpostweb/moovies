class ProductCountry < ActiveRecord::Base
  self.table_name = :products_countries

  self.primary_key = :countries_id


  has_many :products, :foreign_key => :products_countries_id

  scope :visible, where(:inprod => 1)
  scope :order, :order => 'countries_name asc'

  def name
    self[I18n.locale]
  end
  
end
