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

class Package < ActiveRecord::Base
  # attr_accessible :title, :body
end
