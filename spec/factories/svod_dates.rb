FactoryGirl.define do
  factory :svod_date do
    imdb_id {Faker::Number.number(10)}
    start_on {10.days.ago}
    end_on {40.days.from_now}
  end
end