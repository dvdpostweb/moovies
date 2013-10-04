class Canva < ActiveRecord::Base
  attr_accessible :content, :name
	has_many :promotions
end