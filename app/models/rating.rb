# == Schema Information
#
# Table name: products_rating
#
#  products_rating_id   :integer          not null, primary key
#  products_id          :integer          default(0), not null
#  products_rating      :integer          default(0), not null
#  products_rating_date :datetime         not null
#  customers_id         :integer
#  rating_type          :string(45)
#  imdb_id              :integer          default(0), not null
#  criteo_status        :integer          default(0), not null
#

class Rating < ActiveRecord::Base
  self.table_name = :products_rating

  self.primary_key = :products_rating_id

  alias_attribute :updated_at, :products_rating_date
  alias_attribute :type, :rating_type
  alias_attribute :value, :products_rating

  before_save :set_defaults
  after_save :set_already_seen, :cache_rating

  validates_presence_of :product
  validates_presence_of :customer
  validates_inclusion_of :value, :in => 0..5

  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :product, :foreign_key => :products_id

  scope :by_customer, lambda { |customer| where(:customers_id => customer.to_param) }

  private
  def set_defaults
    self.updated_at = Time.now.to_s(:db)
    self.type = product.kind
    self.imdb_id = product.imdb_id
  end

  def set_already_seen
    product.seen_customers << customer
  end

  def cache_rating
    product.rate!(value)
  end
end
