Moovies::Application.routes.draw do
  scope ':locale/(:kind)', :locale => /en|fr|nl/, :kind => /normal|adult/ do
    match 'stop_my_subscription' => "stop#show_msg"
  end
end
