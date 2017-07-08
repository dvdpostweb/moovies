Moovies::Application.routes.draw do
  namespace :wister do
    get "auth/jwt"
    get "auth/token_creator"
  end
end
