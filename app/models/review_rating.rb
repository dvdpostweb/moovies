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

  