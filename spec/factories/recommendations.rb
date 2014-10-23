# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recommendation, :class => 'Recommendations' do
    imdb_id nil
    recommendation_id 1
    position ""
  end
end
