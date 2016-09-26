# == Schema Information
#
# Table name: customers
#
#  customers_id                              :integer          not null, primary key
#  group_id                                  :integer          default(1), not null
#  customers_gender                          :string(1)        default("m"), not null
#  customers_firstname                       :string(32)       default(""), not null
#  customers_lastname                        :string(32)       default(""), not null
#  customers_dob                             :datetime
#  email                                     :string(96)       default(""), not null
#  encrypted_password                        :string(255)      default(""), not null
#  customers_default_address_id              :integer          default(1), not null
#  customers_telephone                       :string(32)       default(""), not null
#  customers_newsletter                      :integer          default(0)
#  customers_newsletterpartner               :integer          default(0)
#  customers_abo                             :integer          default(0), not null
#  customers_abo_suspended                   :integer          default(0), not null
#  customers_abo_type                        :integer          default(0), not null
#  customers_next_abo_type                   :integer          default(0), not null
#  customers_abo_validityto                  :datetime
#  customers_abo_discount_recurring_to_date  :date
#  customers_abo_payment_method              :integer          default(0), not null
#  adult_pwd                                 :string(50)
#  ogone_card_type                           :string(50)
#  ogone_card_no                             :string(50)
#  ogone_exp_date                            :string(50)
#  ogone_owner                               :string(255)
#  ogone_cc_expiration_status                :integer          default(0), not null
#  activation_discount_code_id               :integer          default(0)
#  activation_discount_code_type             :string(2)
#  customers_next_discount_code              :integer          default(0)
#  customers_registration_step               :integer          default(31), not null
#  customers_abo_auto_stop_next_reconduction :integer          default(0), not null
#  customers_language                        :integer          default(3), not null
#  is_email_valid                            :integer          default(1)
#  sleep                                     :boolean          default(FALSE), not null
#  filter_id                                 :integer
#  nickname                                  :string(255)
#  reset_password_token                      :string(255)
#  reset_password_sent_at                    :datetime
#  remember_created_at                       :datetime
#  sign_in_count                             :integer          default(0)
#  current_sign_in_at                        :date
#  last_sign_in_at                           :date
#  current_sign_in_ip                        :string(255)
#  last_sign_in_ip                           :string(255)
#  created_at                                :datetime
#  updated_at                                :datetime
#  confirmation_token                        :string(255)
#  confirmed_at                              :datetime
#  confirmation_sent_at                      :datetime
#  unconfirmed_email                         :string(255)
#  sexuality                                 :integer          default(0)
#  mail_copy                                 :integer          default(1)
#  customers_locked__for_reconduction        :integer          default(0), not null
#  welcomecall_hour                          :integer
#  welcomecall_done                          :integer          default(0)
#  welcomecall_day                           :date
#  tvod_free                                 :integer          default(0)
#  credits_already_recieved                  :integer          default(0)
#

FactoryGirl.define do
  factory :customer do
    email { Faker::Internet.email }
    customers_firstname { Faker::Name.first_name }
    customers_lastname { Faker::Name.last_name }
    pwd = 'titi1500'
    password { pwd }
    password_confirmation { pwd }
    confirmed_at { 10.minutes.ago }
    customers_abo { 1 }
    customers_registration_step { 100 }
  end
end
