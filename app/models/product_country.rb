# == Schema Information
#
# Table name: products_countries
#
#  countries_id   :integer          default(0), not null, primary key
#  countries_name :string(64)       default(""), not null
#  inprod         :integer          default(0), not null
#  fr             :string(64)
#  nl             :string(64)
#  en             :string(64)
#

class ProductCountry < ActiveRecord::Base
  self.table_name = :products_countries

  self.primary_key = :countries_id


  has_many :products, :foreign_key => :products_countries_id

  scope :visible, where(:inprod => 1)
  scope :ordered, :order => 'countries_name asc'

  def name
    self[I18n.locale]
  end
  
end
