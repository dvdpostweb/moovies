class Recommendation < ActiveRecord::Base
  belongs_to :product, :foreign_key => :recommendation_id, :primary_key => :imdb_id
  attr_accessible :position, :recommendation_id
end
