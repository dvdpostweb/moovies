# == Schema Information
#
# Table name: packages
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  type        :string(4)        default("SVOD")
#  group       :integer
#

require 'spec_helper'

describe Package do
  pending "add some examples to (or delete) #{__FILE__}"
end
