Moovies::Application.routes.draw do
  namespace :wister do
    get "auth/jwt"
    get "auth/token_creator"
    scope "/:locale", locale: /#{I18n.available_locales.join("|")}/ do
      get "info/conditions"
    end
  end
end
