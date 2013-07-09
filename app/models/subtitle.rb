class Subtitle < ActiveRecord::Base

  set_table_name :products_undertitles

  set_primary_key :undertitles_id

  alias_attribute :name, :undertitles_description

  has_and_belongs_to_many :products, :join_table => :products_to_undertitles, :foreign_key => :products_undertitles_id, :association_foreign_key => :products_id

  scope :by_language, lambda {|language| where(:language_id => DVDPost.product_languages[language])}
  scope :preferred, where(:undertitles_id => [1, 2, 3])
  scope :preferred_serie, where(:undertitles_id => [1, 2, 3])
  scope :not_preferred, where("undertitles_id not in (?)", [1, 2, 3])
  

  def code
    case id
    when 1
      'fr'
    when 2
      'nl'
    when 3
      'en'
    else
      ''
    end
  end

  def without_sub?
    id == 38
  end
end
