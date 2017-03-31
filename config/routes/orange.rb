Moovies::Application.routes.draw do
  namespace :orange do
    namespace :lu do
      namespace :auth do
        scope "/:locale", locale: /#{I18n.available_locales.join("|")}/ do
          get "sms/authorization"
        end
      end
      namespace :api do
        match "is_eligable" => "webservice#is_eligable"
        match "orange_purchase" => "webservice#orange_purchase"
      end
    end
  end
end