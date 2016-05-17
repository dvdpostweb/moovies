# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    provider "MyString"
    uid "MyString"
    name "MyString"
    image "MyString"
    token "MyString"
    expires_at "2016-05-17 21:48:13"
  end
end
