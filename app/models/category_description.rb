# == Schema Information
#
# Table name: categories_description
#
#  categories_id   :integer          default(0), not null
#  language_id     :integer          default(1), not null
#  categories_name :string(64)       default(""), not null
#

class CategoryDescription < ActiveRecord::Base
  self.table_name = :categories_description

  alias_attribute :name, :categories_name

  belongs_to :category

  scope :by_language, lambda {|language| where(:language_id => Moovies.languages[language])}
end
