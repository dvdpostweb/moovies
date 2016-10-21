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
      match "convert_unlimited_to_plush_a_la_carte" => "validator#convert_unlimited_to_plush_a_la_carte"
      match "convert_plush_a_la_carte_to_unlimited" => "validator#convert_plush_a_la_carte_to_unlimited"
    end
  end
end
