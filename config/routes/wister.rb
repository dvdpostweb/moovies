Moovies::Application.routes.draw do
  namespace :wister do
    get "auth/jwt"
  end
end
