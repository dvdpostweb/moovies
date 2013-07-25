Moovies::Application.routes.draw do

  root :to => 'home#index'
  scope ':locale/(:kind)', :locale => /en|fr|nl/, :kind => /normal|adult/ do
    root :to => 'home#index'
    devise_for :customers, :controllers => { :registrations => "customers/registrations" }
    resources :customers do
      match 'newsletter' => 'customers#newsletter', :only => [:update]
      #mail_copy 'mail_copy', :controller => :customers, :action => :mail_copy, :only => [:update]
      #newsletters_x 'newsletters_x', :controller => :customers, :action => :newsletters_x, :only => [:update]
      #newsletter_x 'newsletter_x', :controller => :customers, :action => :newsletter_x, :conditions => {:method => :get}
      #sexuality 'sexuality', :controller => :customers, :action => :sexuality, :only => [:update]
      resource 'addresses', :only => [:edit, :update, :create]
      resource 'suspension', :only => [:new, :create, :destroy]
      resource 'promotion', :only => [:show, :edit]
      resource :payment_methods, :only => [:edit, :update, :show]
      
      resources :reviews, :only => [:index]
    end
    resources :reviews, :only => :show do
      resource :review_rating, :only => :create
    end
    resources :messages
    resources :tickets do
      resources :message_tickets, :only => [:create]
    end
    resources :products, :only => [:index, :show] do
      resource :rating, :only => :create
      resources :reviews, :only => [:new, :create]
      resources :tokens, :only => [:new, :create]
      match 'step' => 'products#step'
      match 'awards'=> 'products#awards'
      match 'seen' => 'products#seen'
      match 'trailer' => 'products#trailer'
      match 'uninterested' => 'products#uninterested'
    end

    concern :productable do
      resources :products, :only => :index
    end

    resources :categories, :only => [:index], concerns: :productable
    resources :actors, :only => [:index], concerns: :productable
    resources :directors, :only => [], concerns: :productable
    resources :studios, :only => [:index], concerns: :productable
    resources :phone_requests, :only => [:new, :create]
    get 'faq', :to => 'messages#faq'
    match 'info/:page_name' => 'info#index', :as => :info
    match 'steps/:page_name' => 'steps#index', :as => :step
    resources :watchlists, :as => :vod_wishlists
    match 'display_vod' => 'watchlists#display_vod'
    resources :search_filters, :only => [:create, :destroy]
    match 'search/(:search)' => 'search#index', :as => :search
  end
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
