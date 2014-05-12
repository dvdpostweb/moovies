class SvodDate < ActiveRecord::Base
  scope :current, where('(start_on <= date(now()) and end_on >= date(now())) or (start_on > date(now()))')
  scope :svod, where('start_on <= date(now()) and end_on >= date(now())')
  scope :order, order("start_on asc")
  scope :prepaid_svod, where('prepaid_start_on <= date(now()) and prepaid_end_on >= date(now()) and kind = "PREPAID_SVOD"') 
  scope :prepaid_all, where('prepaid_start_on <= date(now()) and prepaid_end_on >= date(now()) and kind = "PREPAID_ALL"') 
end
