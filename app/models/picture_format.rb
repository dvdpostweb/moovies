# == Schema Information
#
# Table name: picture_format
#
#  picture_format_id   :integer          default(0), not null, primary key
#  language_id         :integer          default(0), not null
#  picture_format_name :string(50)       default(""), not null
#

class PictureFormat < ActiveRecord::Base
  self.table_name = :picture_format

  self.primary_key = :picture_format_id

  alias_attribute :name, :picture_format_name

  has_many :products, :foreign_key => :products_picture_format

  scope :by_language, lambda { |language| where(:language_id => Moovies.languages[language.to_s]) }
end
