# == Schema Information
#
# Table name: products_description
#
#  products_id          :integer          default(0), not null, primary key
#  language_id          :integer          default(1), not null
#  products_name        :string(100)      default(""), not null
#  products_description :text
#  products_bonus       :text             default(""), not null
#  products_url         :string(255)
#  products_awards      :text             default(""), not null
#  products_viewed      :integer          default(0)
#  products_image_big   :string(50)       default(""), not null
#  cached_name          :string(255)
#

class ProductDescription < ActiveRecord::Base

  self.table_name = :products_description

  self.primary_key = :products_id
  alias_attribute :text, :products_description
  alias_attribute :title, :products_name
  alias_attribute :url, :products_url
  alias_attribute :image, :products_image_big
  alias_attribute :viewed, :products_viewed

  belongs_to :product

  scope :by_language, lambda { |language| where(:language_id => Moovies.languages[language]) }


  def self.seo
    ProductDescription.where('products_name is not null and products_name !="" and products_id >=51').each do |p|
      connection.execute("update products_description set cached_name ='#{p.title.parameterize.to_s}' where products_id = #{p.products_id} and language_id = #{p.language_id}")
    end
  end

  def full_url
    File.join('http://', url)
  end

  def url_present?
    url? && !url.empty?
  end
end
