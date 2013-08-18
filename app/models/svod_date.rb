class SvodDate < ActiveRecord::Base
  scope :current, where('(start_on <= date(now()) and end_on >= date(now())) or (start_on > date(now()))')
  scope :order, order("start_on asc")
end
