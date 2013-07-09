class PictureFormat < ActiveRecord::Base
  set_table_name :picture_format

  set_primary_key :picture_format_id

  alias_attribute :name, :picture_format_name

  has_many :products, :foreign_key => :products_picture_format

  scope :by_language, lambda {|language| where(:language_id => DVDPost.product_languages[language.to_s])}
end
