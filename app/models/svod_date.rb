# == Schema Information
#
# Table name: svod_dates
#
#  id               :integer          not null, primary key
#  imdb_id          :integer
#  start_on         :date
#  end_on           :date
#  created_at       :datetime
#  updated_at       :datetime
#  kind             :string(12)       default("NORMAL")
#  prepaid_start_on :date
#  prepaid_end_on   :date
#

class SvodDate < ActiveRecord::Base
  scope :current, where('(start_on <= date(now()) and end_on >= date(now())) or (start_on > date(now()))')
  scope :svod, where('start_on <= date(now()) and end_on >= date(now())')
  scope :order, order("start_on asc")
  scope :prepaid_svod, where('prepaid_start_on <= date(now()) and prepaid_end_on >= date(now()) and kind = "PREPAID_SVOD"') 
  scope :prepaid_all, where('prepaid_start_on <= date(now()) and prepaid_end_on >= date(now()) and kind = "PREPAID_ALL"') 
end
