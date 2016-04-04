# == Schema Information
#
# Table name: recommendations
#
#  id                :integer          not null, primary key
#  imdb_id           :integer
#  recommendation_id :integer
#  position          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Recommendation < ActiveRecord::Base
  belongs_to :product, :foreign_key => :recommendation_id, :primary_key => :imdb_id
  scope :ordered, :order => 'position asc'
end
