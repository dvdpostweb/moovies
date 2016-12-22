Moovies::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      match "check_presence_of_customer_email" => "validator#check_presence_of_customer_email"
      match "check_presence_of_customer_email_registration" => "validator#check_presence_of_customer_email_registration"
      match "check_presence_of_activation_code" => "validator#check_activation_code_presence"
      match "check_presence_of_activation_code_carrefour" => "validator#check_activation_code_presence_carrefour"
      match "activate_new_plan" => "validator#set_plan"
      match "login" => "login#login"
      match "register" => "registration#register"
      match "promotion_code_activation" => "validator#check_and_validate_public_promotions_activation_codes"
      match "virement" => "virement#accept_virement_payment"
      match "subscriptions" => "subscriptions#for_logedin_customers"
      match "subscriptions_freetrial_mobistar_customers" => "subscriptions#for_logedin_mobistar_customers_freetrial_subscription"
      match "ogone_parameters_accepturl" => "ogone_tokenization#ogone_parameters_accepturl"
    end
  end
end
