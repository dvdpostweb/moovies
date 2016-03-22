# == Schema Information
#
# Table name: promotions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  canva_id   :integer
#  params     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Promotion do
  pending "add some examples to (or delete) #{__FILE__}"
end
