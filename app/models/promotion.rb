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

class Promotion < ActiveRecord::Base
  include ActiveModel::Serialization
  attr_accessible :canva_id, :name, :params
  serialize :params
  belongs_to :canva
end
