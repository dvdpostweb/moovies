class Country < ActiveRecord::Base
  self.table_name = :country
  self.primary_key = :countries_id

  alias_attribute :name, :countries_name
end