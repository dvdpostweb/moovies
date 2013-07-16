class ReviewRating < ActiveRecord::Base
  self.table_name = :reviews_rating

  alias_attribute :value, :reviews_interesting

  belongs_to :review
  belongs_to :customer, :foreign_key => :customers_id
  
  scope :by_customer, lambda {|customer| where(:customers_id => customer.to_param)}
end

  