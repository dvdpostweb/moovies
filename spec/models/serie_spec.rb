# == Schema Information
#
# Table name: series
#
#  series_id      :integer          not null, primary key
#  series_name    :string(255)      default(""), not null
#  parent_id      :integer
#  series_type_id :integer
#  name_fr        :string(255)
#  name_nl        :string(255)
#  name_en        :string(255)
#

require 'spec_helper'

describe Serie do
  pending "add some examples to (or delete) #{__FILE__}"
end
