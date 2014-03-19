# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lucky_cycle do
    canplay false
    message "MyString"
    token_id 1
    customer_id 1
    computed_hash "MyString"
    poke_counter 1
    firstname "MyString"
    lastname "MyString"
    email "MyString"
  end
end
