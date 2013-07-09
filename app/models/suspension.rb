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