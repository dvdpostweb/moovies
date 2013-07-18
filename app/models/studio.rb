class Studio < ActiveRecord::Base

  self.primary_key = :studio_id

  self.table_name = :studio

  alias_attribute :name, :studio_name

  scope :by_letter, lambda {|letter| where("studio_name like ?", "#{letter}%" )}
  scope :by_kind, lambda {|kind| where(:studio_type => Moovies.actor_kinds[kind])}
  scope :by_number, where("studio_name REGEXP '^[0-9]'")
  scope :vod_be, where(:vod_be => true)
  scope :vod_lux, where(:vod_lux => true)
  scope :vod_nl, where(:vod_nl => true)
  scope :ordered, :order => 'studio_name'
  

  has_many :products, :foreign_key => :products_studio

  def image
    File.join(Moovies.images_path, "distributors", "#{id}b.jpg")
  end
end