class Promotion < ActiveRecord::Base
  include ActiveModel::Serialization
  attr_accessible :canva_id, :name, :params
  serialize :params
  belongs_to :canva
end
