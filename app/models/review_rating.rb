# == Schema Information
#
# Table name: reviews_rating
#
#  review_id           :integer          default(0), not null
#  customers_id        :integer          default(0), not null
#  reviews_interesting :integer          default(0), not null
#  created_at          :datetime
#  updated_at          :datetime
#  source              :string(40)       default("DVDPOST"), not null
#

class ReviewRating < ActiveRecord::Base
  establish_connection "common_#{Rails.env}"
  self.table_name = :reviews_rating

  alias_attribute :value, :reviews_interesting

  belongs_to :review
  belongs_to :customer, :foreign_key => :customers_id
  before_create :set_source
  scope :by_customer, lambda {|customer| where(:customers_id => customer.to_param, :source => 'PLUSH')}

  private
  def set_source
    self.source = 'PLUSH'
  end
end

  
