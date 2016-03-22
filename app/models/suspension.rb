# == Schema Information
#
# Table name: suspensions
#
#  id            :integer          not null, primary key
#  customer_id   :integer          not null
#  status        :string(8)        default("HOLIDAYS"), not null
#  date_added    :datetime
#  date_end      :datetime
#  last_modified :datetime
#  user_modified :integer          not null
#

class Suspension < ActiveRecord::Base

  attr_reader :duration

  scope :holidays, where(:status => 'HOLIDAYS')
  scope :last_year, where(:date_added => 1.year.ago.localtime..Time.now)

  def self.duration
    duration = OrderedHash.new
    duration.push(7 , :one_weeks  ) 
    duration.push(14, :two_weeks  )
    duration.push(21, :tree_weeks )
    duration.push(30, :one_months )
    duration
  end
end
