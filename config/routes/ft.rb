Moovies::Application.routes.draw do

  scope ':locale/(:kind)', :locale => /en|fr|nl/, :kind => /normal|adult/ do
    match "freetrial_action" => "newfreetrialregistrationlogin#show"
  end

  namespace :api do
    namespace :v1 do
      namespace :ft do
        match "l_v" => "ft_v#l_v"
        match "l_p_v" => "ft_v#l_p_v"
        match "r_v" => "ft_v#r_v"
        match "login" => "ft_l#login"
        match "register" => "ft_r#register"
      end
    end
  end

end
