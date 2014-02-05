FactoryGirl.define do
  factory :customer do
    email {Faker::Internet.email}
    customers_firstname {Faker::Name.first_name}
    customers_lastname {Faker::Name.last_name}
    pwd = 'titi1500'
    password { pwd }
    password_confirmation { pwd }
    confirmed_at {10.minutes.ago}
    customers_abo {1}
    customers_registration_step {100}
  end
end