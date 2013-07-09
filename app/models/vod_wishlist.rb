class VodWishlist < ActiveRecord::Base
  
  has_many :products, :self.primary_key =ry_key => :imdb_id, :foreign_key => :imdb_id
  has_many :streaming_products, :self.primary_key =ry_key => :imdb_id, :foreign_key => :imdb_id
  has_many :tokens, :self.primary_key =ry_key => :imdb_id, :foreign_key => :imdb_id
end
