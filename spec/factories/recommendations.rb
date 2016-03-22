# == Schema Information
#
# Table name: recommendations
#
#  id                :integer          not null, primary key
#  imdb_id           :integer
#  recommendation_id :integer
#  position          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recommendation, :class => 'Recommendations' do
    imdb_id nil
    recommendation_id 1
    position ""
  end
end
