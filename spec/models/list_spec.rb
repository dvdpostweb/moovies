# == Schema Information
#
# Table name: lists
#
#  id         :integer          not null, primary key
#  product_id :integer
#  fr         :boolean
#  nl         :boolean
#  en         :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe List do
  pending "add some examples to (or delete) #{__FILE__}"
end
