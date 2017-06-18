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

class List < ActiveRecord::Base
  has_many :products
end
