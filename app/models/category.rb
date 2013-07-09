class Category < ActiveRecord::Base
  self.primary_key = :categories_id

  belongs_to :parent, :class_name => 'Category', :foreign_key => :parent_id
  has_many :descriptions, :class_name => 'CategoryDescription', :foreign_key => :categories_id
  has_and_belongs_to_many :products, :join_table => :products_to_categories, :foreign_key => :categories_id, :association_foreign_key => :products_id
  has_many :children, :class_name => 'Category', :foreign_key => :parent_id

  scope :by_kind, lambda {|kind| {where(:categories_type => DVDPost.product_kinds[kind])}
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

  def name
    descriptions.by_language(I18n.locale).first.name
  end

  def root?
    parent_id == 0
  end

  def image
    File.join(DVDPost.images_path, "categories", "#{id}.jpg")
  end

  def image_vod
    File.join(DVDPost.images_path, "categories", "#{id}_vod.jpg")
  end

end
