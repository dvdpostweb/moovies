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

FactoryGirl.define do
  factory :svod_date do
    imdb_id { Faker::Number.number(10) }
    start_on { 10.days.ago }
    end_on { 40.days.from_now }
  end
end
