# == Schema Information
#
# Table name: public
#
#  public_id   :integer          default(0), not null, primary key
#  language_id :integer          default(0), not null
#  public_name :string(50)       default(""), not null
#

class Public < ActiveRecord::Base
  self.table_name = :public

  self.primary_key = :public_id

  alias_attribute :description, :public_name

  belongs_to :product

  def name
    Moovies.local_product_publics[to_param.to_i]
  end

  def image
    "public_#{name}.gif"
  end

  def self.legacy_age_ids(min, max)
    ages = []
    if max.to_i == 0
      ages << Moovies.product_publics[:all]
    else
      ages << Moovies.product_publics.keys.collect do |age|
        Moovies.product_publics[age] if age != :all && age.to_i.between?(min.to_i, max.to_i)
      end
    end
    ages.flatten.uniq.compact
  end
end
