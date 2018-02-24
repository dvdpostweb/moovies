Moovies::Application.routes.draw do
  namespace :mobile do
    scope ':locale/(:kind)', :locale => /en|fr|nl/, :kind => /normal|adult/ do
      get "privacy/info"
    end
  end
end