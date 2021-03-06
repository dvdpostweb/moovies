Moovies::Application.routes.draw do

  match "angular_test" => "angular_test#index"

  match "renew_monthly_credits_for_a_la_carte" => "renew_monthly_subscription#renew_monthly_credits_for_a_la_carte"
  match "social_activation" => "social_activation#activate"
  match '/auth/:provider/callback' => 'authentications#create'
  match 'canvas' => 'authentications#canvas'

  concern :productable do
    resources :products, :only => :index
  end

  root to: 'products#index'

  resource :ogone, :only => [:create]
  resource :home_products, :only => [:update, :edit]
  resource :list, :only => [:new, :create]

  match 'flag' => 'home#flag'
  resources :prospects, :only => [:create, :new]
  scope '(:kind)', :kind => /normal|adult/ do
    localized do
      devise_for :customers, :controllers => {
        :registrations => "customers/registrations",
        :sessions => "customers/sessions"#,
        #:passwords => "customers/passwords"
      }
      resources :customers do
        match 'newsletter' => 'customers#newsletter', :only => [:update]
        resource 'addresses', :only => [:edit, :update, :create]
        resource 'suspension', :only => [:new, :create, :destroy]
        resource 'promotion', :only => [:show, :edit]
        resource 'images', :only => [:create]
        resource :payment_methods, :only => [:edit, :update, :show]
        resources :reviews, :only => [:index]
      end
      match 'info/:page_name' => 'info#index', :as => :info
      match 'streaming_products/sample', :to => 'streaming_products#sample'
      resources :streaming_products, :only => [:show] do
        match 'language' => 'streaming_products#language'
        match 'subtitle' => 'streaming_products#subtitle'
        match 'versions' => 'streaming_products#versions'
      end
      resources :products, :only => [:show], constraints: { :id => /[0-9]+[0-9a-zA-Z\-_]*/ }
      resources :products, :only => [], constraints: { :product_id => /[0-9]+[0-9a-zA-Z\-_]*/ } do
        resource :rating, :only => :create
        resources :reviews, :only => [:new, :create]
        #resources :tokens, :only => [:new, :create]
        match 'step' => 'products#step'
        match 'awards'=> 'products#awards'
        match 'seen' => 'products#seen'
        match 'trailer' => 'products#trailer'
        match 'uninterested' => 'products#uninterested'
        match 'action' => 'products#action'
        match 'log' => 'products#log'
        match 'data' => 'products#data'
        match 'sign_up' => 'products#sign_up'
      end
      match 'products(/:package)(/:view_mode)' => 'products#index', :as => :products_short
      resources :phone_requests, :only => [:new, :create, :index]
      resources :actors, :only => [:index], concerns: :productable
      resources :directors, :only => [], concerns: :productable
    end
  end

  root_path = 'products#index'

  scope ':locale/(:kind)', :locale => /en|fr|nl/, :kind => /normal|adult/ do
    match 'orangesmsconfirm' => 'orangeconfirm#promotion'
  	match "carrefourbonus" => "carrefourbonus#plans"
    match "freetrial" => "freetrial#plans"
    match "photobox" => "photobox#plans"
    match 'carrefour' => 'home#carrefour'
    match 'belgium' => "home#belgium"
    match 'halloween' => "halloween#collection"
    resource :public_promotion, :only => [:edit, :update]
    match "/" => 'products#index', :as => :root_localize
    match "validation" => 'home#validation'
    match 'customers/promotion' => "customers#promotion"
    devise_for :customers, :controllers => {
        :registrations => "customers/registrations",
        :confirmations => "customers/confirmations"#,
        #:passwords => "customers/passwords"
    }, :as => :old_customers
    resources :customers, :as => :old_customer do
      match 'newsletter' => 'customers#newsletter', :only => [:update]
      resource 'addresses', :only => [:edit, :update, :create]
      resource 'suspension', :only => [:new, :create, :destroy]
      resource 'promotion', :only => [:show, :edit]
      resource 'images', :only => [:create]
      resource :payment_methods, :only => [:edit, :update, :show]
      resources :reviews, :only => [:index]
    end
    match 'info/:page_name' => 'info#index', :as => :info_old

    resources :products, :only => [:index, :show], :as => :old_products do
      resource :rating, :only => :create
      resources :reviews, :only => [:new, :create]
      resources :tokens, :only => [:new, :create]
      match 'awards'=> 'products#awards'
      match 'seen' => 'products#seen'
      match 'trailer' => 'products#trailer'
      match 'uninterested' => 'products#uninterested'
      match 'action' => 'products#action'
      match 'log' => 'products#log'
    end
    resources :phone_requests, :only => [:new, :create, :index], :as => :old_phone_requests
    match 'search/(:search)' => 'search#index', :as => :search
    resources :public_newsletters, :only => [:new, :create]
    resources :reviews, :only => :show do
      resource :review_rating, :only => :create
    end
    match "messages/urgent" => "messages#urgent"
    resources :messages
    resources :tickets do
      resources :message_tickets, :only => [:create]
    end
    resources :promotions, :only => [:show]
    post 'promotions/:id' => "promotions#create", :as => :promotion_canva
    resource :subscription, :only => [:update]
    resources :categories, :only => [:index], concerns: :productable
    resources :actors, :only => [:index], concerns: :productable, :as => :old_actors
    resources :directors, :only => [], concerns: :productable, :as => :old_directors
    resources :studios, :only => [:index], concerns: :productable
    get 'faq', :to => 'messages#faq'

    resources :steps, :only => [:show, :update]
    resources :watchlists, :as => :vod_wishlists
    match 'display_vod' => 'watchlists#display_vod'
    resource :search_filters, :only => [:update, :destroy]
    match 'streaming_products/sample', :to => 'streaming_products#sample', :as => :old_streaming_products_sample
    resources :streaming_products, :only => [:show], :as => :old_streaming_products do
      match 'language' => 'streaming_products#language'
      match 'subtitle' => 'streaming_products#subtitle'
      match 'versions' => 'streaming_products#versions'
    end
    get 'unsubscribe', :to => 'customers#unsubscribe'
    get 'back_to_tvod', :to => 'customers#back_to_tvod'
    #match ':id' => "promotions#show", :as => :promotion_localize, constraints: lambda { |request| Promotion.find_by_name(request.path_parameters[:id]) || 'samsung' }
    get ':id' => "promotions#show", :as => :promotion_localize, :id => /samsung|promotion/
    post ':id' => "promotions#create", :as => :promotion_localize, :id => /samsung|promotion/

  end


  get ':id' => "promotions#show", defaults: { format: 'choose' }, :as => :promotion, :id => /smarttv|radio_contact|samsung|nostalgie|playstation/, :as => :short_promotion
  post ':id' => "promotions#show", defaults: { format: 'choose' }, :as => :promotion, :id => /smarttv|radio_contact|samsung|nostalgie/, :as => :short_promotion
  resources :promotions, defaults: { format: 'choose' }, :only => [:show], :as => :root_promotion

  match "/404", :to => "errors#not_found"
  match "/500", :to => "errors#not_found"

end
