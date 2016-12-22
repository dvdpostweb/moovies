Moovies::Application.routes.draw do
  namespace :api do
    namespace :v1 do

      match "express_checkout" => "paypal#express_checkout"
      match "express_checkout_return" => "paypal#express_checkout_return"

      match "express_checkout_payment_method_change_to_paypal" => "paypal#express_checkout_payment_method_change_to_paypal"
      match "express_checkout_return_payment_method_change_to_paypal" => "paypal#express_checkout_return_payment_method_change_to_paypal"
      
    end
  end
end
