class Address < ActiveRecord::Base
  self.table_name = :address_book
  self.primary_keys = :customers_id, :address_book_id

  before_save :replace_semicolon
  before_create :set_default
  attr_accessible :first_name, :last_name, :street, :postal_code, :city, :country_id, :customers_id, :entry_country_id, :entry_gender, :address_book_id, :customer, :gender
  belongs_to :customer, :foreign_key => :customers_id
  alias_attribute :first_name, :entry_firstname
  alias_attribute :last_name, :entry_lastname
  alias_attribute :street, :entry_street_address
  alias_attribute :postal_code, :entry_postcode
  alias_attribute :city, :entry_city
  alias_attribute :country_id, :entry_country_id
  alias_attribute :gender, :entry_gender
  alias_attribute :address_id, :address_book_id
  

  validates_length_of :first_name, :minimum => 2
  validates_length_of :last_name, :minimum => 2
  validates_length_of :street, :minimum => 5
  validates_length_of :postal_code, :minimum => 4, :maximum => 7
  validates_length_of :city, :minimum => 1

  def replace_semicolon
    self.street = self.street.gsub(/;/, ' ').gsub(/   /,' ').gsub(/  /,' ')
  end

  def belgian?
    country_id == 21
  end

  def luxemburg?
    country_id == 124
  end

  def nederlands?
    country_id == 150
  end

  def name
    "#{first_name} #{last_name}"
  end

  private
   def set_default
     self.address_book_id = self.customer.addresses.count > 0 ? self.customer.addresses.maximum(:address_book_id) + 1 : 1
     self.gender = self.customer.gender if self.gender.nil? || self.gender.empty?
     self.entry_country_id = self.customer.address ? self.customer.address.entry_country_id : 21
     self.first_name = self.customer.first_name unless self.first_name
     self.last_name = self.customer.last_name unless self.last_name
   end
   
   
end
