class Recommendation < ActiveRecord::Base
  belongs_to :product, :foreign_key => :recommendation_id, :primary_key => :imdb_id
  scope :ordered, :order => 'position asc'
end
