Moovies::Application.routes.draw do
  namespace :orange do
    namespace :lu do
      namespace :auth do
        scope "/:locale", locale: /#{I18n.available_locales.join("|")}/ do
          get "sms/authorization"
          get "sms/registration"
        end
        get "sms/download"
        match "orange_sms_auto_login" => "sms#orange_sms_auto_login"
      end
      namespace :api do
        match "orange_is_eligable" => "webservice#orange_is_eligable"
        match "orange_is_eligable_ppv" => "webservice#orange_is_eligable_ppv"
        match "orange_is_eligable_step3" => "webservice#orange_is_eligable_step3"
        match "orange_register" => "webservice#orange_register"
        match "orange_login" => "webservice#orange_login"
        match "orange_purchase" => "webservice#orange_purchase"
        match "orange_purchase_ppv" => "webservice#orange_purchase_ppv"
        match "orange_purchase_step3" => "webservice#orange_purchase_step3"
        match "check_sms_activation_code" => "webservice#check_sms_activation_code"
        match "automatic_login" => "webservice#automatic_login"
        match "automatic_register" => "webservice#automatic_register"
        match "convert_to_customer" => "webservice#convert_to_customer"
        match "orange_stop" => "webservice#orange_stop"
      end
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :orange do
        match "ppv" => "auth#ppv"
        namespace :callbacks do
          get "wha/success"
          get "wha/cancel"
          #get "wha/orangemobile"
          match "orangemobile" => "ios#orangemobile"
          match "ioscallback" => "ios#ioscallback"
        end
      end
    end
  end

end
