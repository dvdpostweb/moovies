class CategoryDescription < ActiveRecord::Base
  self.table_name = :categories_description

  alias_attribute :name, :categories_name

  belongs_to :category

  scope :by_language, lambda {|language| where(:language_id => Moovies.languages[language])}
end