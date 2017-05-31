# == Schema Information
#
# Table name: mobistars
#
#  activation_id :integer          default(0), not null, primary key
#

class Mobistar < ActiveRecord::Base
	#belongs_to :customer
	attr_accessor :activation_id
end
