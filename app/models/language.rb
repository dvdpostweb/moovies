class Language < ActiveRecord::Base
  set_table_name :products_languages

  set_primary_key :languages_id

  alias_attribute :name, :languages_description

  has_and_belongs_to_many :products, :join_table => :products_to_languages, :foreign_key => :products_languages_id, :association_foreign_key => :products_id

  scope :by_language, lambda {|language| {where(:languagenav_id => DVDPost.product_languages[language])}
  scope :preferred, where(:languages_id => [1, 2, 3])
  scope :preferred_serie, where(:languages_id => [1, 2, 3])
  scope :not_preferred, where("languages_id not in (?)", [1, 2, 3])
  

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
end
