# == Schema Information
#
# Table name: studio
#
#  studio_id                   :integer          not null, primary key
#  studio_name                 :string(50)       default(""), not null
#  studio_type                 :string(9)        default("DVD_NORM"), not null
#  cost_for_new                :float            default(1.0), not null
#  cost                        :float            default(1.0), not null
#  vod_be                      :boolean          default(FALSE), not null
#  fee_new_vod                 :float
#  fee_back_catalogue          :float
#  minimum_new_vod             :float
#  minimum_back_catalogue      :float
#  minimum_global              :float
#  billing_reporting           :integer          default(0), not null
#  vod_lux                     :boolean          default(FALSE), not null
#  vod_nl                      :boolean          default(FALSE), not null
#  plush_price_new             :float
#  plush_price_back_catalogue  :float
#  svod_fee_new_vod            :float
#  svod_fee_back_catalogue     :float
#  svod_minimum_new_vod        :float
#  svod_minimum_back_catalogue :float
#  svod_minimum_global         :float
#

class Studio < ActiveRecord::Base

  self.primary_key = :studio_id

  self.table_name = :studio

  alias_attribute :name, :studio_name

  scope :by_letter, lambda { |letter| where("studio_name like ?", "#{letter}%") }
  scope :by_kind, lambda { |kind| where(:studio_type => Moovies.actor_kinds[kind]) }
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
