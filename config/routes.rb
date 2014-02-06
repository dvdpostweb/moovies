Moovies::Application.routes.draw do

  get "prospects/create"

  concern :productable do
    resources :products, :only => :index
  end

  root :to => 'home#index'
  resource :ogone, :only => [:create]
  match 'flag' => 'home#flag'
  resources :prospects, :only => [:create, :new]
  scope '(:kind)', :kind => /normal|adult/ do
    localized do
      devise_for :customers, :controllers => { :registrations => "customers/registrations", :confirmations => "customers/confirmations", :sessions => "customers/sessions" }
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
      match 'streaming_products/faq', :to => 'streaming_products#faq'
      match 'streaming_products/sample', :to => 'streaming_products#sample'
      resources :streaming_products, :only => [:show] do
        match 'language' => 'streaming_products#language'
        match 'subtitle' => 'streaming_products#subtitle'
        match 'versions' => 'streaming_products#versions'
      end
      resources :products, :only => [:show], constraints: { :id => /[0-9]+[0-9a-z\-]*/ }
      resources :products, :only => [], constraints: { :product_id => /[0-9]+[0-9a-z\-]*/ } do
        resource :rating, :only => :create
        resources :reviews, :only => [:new, :create]
        resources :tokens, :only => [:new, :create]
        match 'step' => 'products#step'
        match 'awards'=> 'products#awards'
        match 'seen' => 'products#seen'
        match 'trailer' => 'products#trailer'
        match 'uninterested' => 'products#uninterested'
        match 'action' => 'products#action'
        match 'log' => 'products#log'
      end
      match 'products(/:package)(/:view_mode)' => 'products#index', :as => :products_short
      resources :phone_requests, :only => [:new, :create, :index]
      resources :actors, :only => [:index], concerns: :productable
      resources :directors, :only => [], concerns: :productable
      
    end
  end
  scope ':locale/(:kind)', :locale => /en|fr|nl/, :kind => /normal|adult/ do
    match "/" => 'home#index', :as => :root_localize
    match "validation" => 'home#validation'
    
    devise_for :customers, :controllers => { :registrations => "customers/registrations", :confirmations => "customers/confirmations" }, :as => :old_customers
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
    match 'streaming_products/faq', :to => 'streaming_products#faq', :as => :old_streaming_products_faq
    match 'streaming_products/sample', :to => 'streaming_products#sample', :as => :old_streaming_products_sample
    resources :streaming_products, :only => [:show], :as => :old_streaming_products do
      match 'language' => 'streaming_products#language'
      match 'subtitle' => 'streaming_products#subtitle'
      match 'versions' => 'streaming_products#versions'
    end
    get 'unsubscribe', :to => 'customers#unsubscribe'    
    #match ':id' => "promotions#show", :as => :promotion_localize, constraints: lambda { |request| Promotion.find_by_name(request.path_parameters[:id]) || 'samsung' }
    get ':id' => "promotions#show", :as => :promotion_localize, :id => /samsung|promotion/
    post ':id' => "promotions#create", :as => :promotion_localize, :id => /samsung|promotion/
    
  end
  
  
  get ':id' => "promotions#show", defaults: { format: 'choose' }, :as => :promotion, :id => /smarttv|radio_contact|samsung|nostalgie/, :as => :short_promotion
  post ':id' => "promotions#show", defaults: { format: 'choose' }, :as => :promotion, :id => /smarttv|radio_contact|samsung|nostalgie/, :as => :short_promotion
  resources :promotions, defaults: { format: 'choose' }, :only => [:show], :as => :root_promotion

  match "/404", :to => "errors#not_found"
  match "/500", :to => "errors#not_found"
  
  #unless Rails.application.config.consider_all_requests_local
  #      match '*not_found', to: 'errors#error_404'
  #end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  
end
