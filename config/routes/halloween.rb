Moovies::Application.routes.draw do
  scope ':locale/(:kind)', :locale => /en|fr|nl/, :kind => /normal|adult/ do
    match 'halloween' => "halloween#collection"
  end
end
