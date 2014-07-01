class Category < ActiveRecord::Base
  include ThinkingSphinx::Scopes
  self.primary_key = :categories_id

  belongs_to :parent, :class_name => 'Category', :foreign_key => :parent_id
  has_many :descriptions, :class_name => 'CategoryDescription', :foreign_key => :categories_id
  has_many :descriptions_fr, :class_name => 'CategoryDescription', :foreign_key => :categories_id, :conditions => {:language_id => 1}
  has_many :descriptions_nl, :class_name => 'CategoryDescription', :foreign_key => :categories_id, :conditions => {:language_id => 2}
  has_many :descriptions_en, :class_name => 'CategoryDescription', :foreign_key => :categories_id, :conditions => {:language_id => 3}
  has_and_belongs_to_many :products, :join_table => :products_to_categories, :foreign_key => :categories_id, :association_foreign_key => :products_id
  has_many :children, :class_name => 'Category', :foreign_key => :parent_id

  scope :by_kind, lambda {|kind| where(:categories_type => Moovies.product_kinds[kind])}
  scope :movies, where(:product_type => 'Movie')
  scope :roots, where(:parent_id => 0)
  scope :visible_on_homepage, where(:show_home => 'YES')
  scope :active, where(:active => 'YES')
  scope :remove_themes, where('categories_id != 105')
  scope :hetero, where('categories_id != 76')
  scope :vod, where(:vod => true)
  
  scope :ordered, :order => 'display_group ASC, sort_order ASC'
  scope :alphabetic_orderd, :order => 'categories_description.categories_name'
  scope :by_size, where("size > 0")
  scope :random, :order => 'rand()'

  sphinx_scope(:active)           {|products_id|      {:with =>       {:active => 1}}}
  sphinx_scope(:by_parent)        {|id|               {:with =>       {:parent_id => id}}}
  sphinx_scope(:by_type)          {|type|             {:with =>       {:type => Zlib::crc32(Moovies.product_kinds[type])}}}
  sphinx_scope(:by_products)      {                   {:without =>    {:count_svod_be => 0}}}
  sphinx_scope(:by_first_fr)      {|letter|           {:with =>       {:first_fr_int => Zlib::crc32(letter)}}}
  
  sphinx_scope(:order)                    {|order, sort_mode| {:order => order, :sort_mode => sort_mode}}

  def description
    case I18n.locale
      when :nl
        descriptions_nl.first
      when :en
        descriptions_en.first
      else
        descriptions_fr.first
      end
  end

  def name
    description.name
  end

  def root?
    parent_id == 0
  end

  def image
    File.join(Moovies.images_path, "categories", "#{id}.jpg")
  end

  def image_vod
    File.join(Moovies.images_path, "categories", "#{id}_vod.jpg")
  end

  def self.not_empty(country, type)
    case country
    when 131 
      "count_#{type}_lu"
    when 161 
      "count_#{type}_nl"
    else 
      "count_#{type}_be"
    end
  end

end
