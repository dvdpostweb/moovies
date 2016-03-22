# == Schema Information
#
# Table name: generalglobalcode
#
#  CodeType        :string(50)       default(""), not null
#  CodeValue       :string(50)       default(""), not null
#  CodeDesc        :string(150)
#  CodeDesc2       :string(150)
#  ParentCodeType  :string(50)
#  ParentCodeValue :string(50)
#

class General < ActiveRecord::Base
  self.table_name = :generalglobalcode

  alias_attribute :type, :CodeType
  alias_attribute :value, :CodeValue
end
