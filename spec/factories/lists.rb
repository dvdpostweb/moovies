# == Schema Information
#
# Table name: lists
#
#  id         :integer          not null, primary key
#  product_id :integer
#  fr         :boolean
#  nl         :boolean
#  en         :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :list do
    product nil
    fr false
    nl false
    en false
  end
end
