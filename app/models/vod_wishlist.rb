# == Schema Information
#
# Table name: vod_wishlists
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  imdb_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  source_id   :integer
#  season_id   :integer          default(0), not null
#  episode_id  :integer          default(0), not null
#

class VodWishlist < ActiveRecord::Base
  has_many :products, :primary_key => [:imdb_id, :season_id, :episode_id], :foreign_key => [:imdb_id, :season_id, :episode_id]
  has_many :streaming_products, :primary_key => :imdb_id, :foreign_key => :imdb_id
  has_many :tokens, :primary_key => :imdb_id, :foreign_key => :imdb_id
  belongs_to :product, :primary_key => [:imdb_id, :season_id, :episode_id], :foreign_key => [:imdb_id, :season_id, :episode_id]
  scope :by_primary, lambda { |imdb_id, season_id, episode_id| where(:imdb_id => imdb_id, :season_id => season_id, :episode_id => episode_id) }
end
