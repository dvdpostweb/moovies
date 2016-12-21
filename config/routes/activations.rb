Moovies::Application.routes.draw do
  namespace :api do
    namespace :v1 do

      match "check_presence_of_activation_code_orange" => "validator#check_activation_code_presence_orange"

      match "check_presence_of_activation_code_carrefour" => "validator#check_activation_code_presence_carrefour"

      match "check_presence_of_activation_code_bnppf" => "validator#check_activation_code_presence_bnppf"

    end
  end
end
