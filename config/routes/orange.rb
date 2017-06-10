Moovies::Application.routes.draw do
  namespace :orange do
    namespace :lu do
      namespace :auth do
        scope "/:locale", locale: /#{I18n.available_locales.join("|")}/ do
          get "sms/authorization"
          get "sms/registration"
        end
      end
      namespace :api do
        match "orange_is_eligable" => "webservice#orange_is_eligable"
        match "orange_register" => "webservice#orange_register"
        match "orange_login" => "webservice#orange_login"
        match "orange_purchase" => "webservice#orange_purchase"
        match "check_sms_activation_code" => "webservice#check_sms_activation_code"
        match "automatic_login" => "webservice#automatic_login"
        match "automatic_register" => "webservice#automatic_register"
      end
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :orange do
        namespace :callbacks do
          get "wha/success"
          get "wha/cancel"
        end
      end
    end
  end

end
