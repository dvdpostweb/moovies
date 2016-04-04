# == Schema Information
#
# Table name: country
#
#  countries_id         :integer          not null, primary key
#  countries_name       :string(64)       default(""), not null
#  countries_iso_code_2 :string(2)        default(""), not null
#  countries_iso_code_3 :string(3)        default(""), not null
#  address_format_id    :integer          default(0), not null
#

class Country < ActiveRecord::Base
  self.table_name = :country
  self.primary_key = :countries_id

  alias_attribute :name, :countries_name
end
