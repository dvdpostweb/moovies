class General < ActiveRecord::Base
  self.table_name = :generalglobalcode

  alias_attribute :type, :CodeType
  alias_attribute :value, :CodeValue
end