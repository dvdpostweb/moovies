class Uninterested < ActiveRecord::Base
  self.table_name = :products_uninterested

  self.primary_key = :products_uninterested_id

  alias_attribute :created_at, :date

  belongs_to :product, :foreign_key => :products_id
  belongs_to :customer, :foreign_key => :customers_id

  before_save :set_created_at

  validates_uniqueness_of :customers_id, :scope => [:customers_id, :products_id]

  scope :by_customer, lambda {|customer| where(:customers_id => customer.to_param)}

  def set_created_at
    self.created_at = Time.now.to_s(:db)
  end
end
