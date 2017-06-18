# == Schema Information
#
# Table name: address_book
#
#  customers_id         :integer          default(0), not null, primary key
#  address_book_id      :integer          default(1), not null, primary key
#  entry_gender         :string(1)        default(""), not null
#  entry_company        :string(32)
#  entry_firstname      :string(32)       default(""), not null
#  entry_lastname       :string(32)       default(""), not null
#  entry_street_address :string(64)       default(""), not null
#  entry_suburb         :string(32)
#  entry_postcode       :string(10)       default(""), not null
#  entry_city           :string(32)       default(""), not null
#  entry_state          :string(32)
#  entry_country_id     :integer          default(0), not null
#  entry_zone_id        :integer          default(0), not null
#  date_added           :timestamp        not null
#

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


  validates_length_of :first_name, :minimum => 2, :if => :svod?
  validates_length_of :last_name, :minimum => 2, :if => :svod?
  validates_length_of :street, :minimum => 5, :if => :svod?
  validates_length_of :postal_code, :minimum => 4, :maximum => 7, :if => :svod?
  validates_length_of :city, :minimum => 1, :if => :svod?

  def replace_semicolon
    self.street = self.street.gsub(/;/, ' ').gsub(/   /, ' ').gsub(/  /, ' ')
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

  def svod?
    customer.abo_type_id != 6
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
