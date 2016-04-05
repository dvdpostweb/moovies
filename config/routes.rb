# == Route Map
#
#                                       root        /                                                                                products#index
#                                      ogone POST   /ogone(.:format)                                                                 ogones#create
#                         edit_home_products GET    /home_products/edit(.:format)                                                    home_products#edit
#                              home_products PUT    /home_products(.:format)                                                         home_products#update
#                                       list POST   /list(.:format)                                                                  lists#create
#                                   new_list GET    /list/new(.:format)                                                              lists#new
#                                       flag        /flag(.:format)                                                                  home#flag
#                                  prospects POST   /prospects(.:format)                                                             prospects#create
#                               new_prospect GET    /prospects/new(.:format)                                                         prospects#new
#                    new_customer_session_fr GET    /fr(/:kind)/mon-compte/connectez-vous(.:format)                                  customers/sessions#new {:kind=>/normal|adult/, :locale=>"fr"}
#                    new_customer_session_nl GET    /nl(/:kind)/mijn-account/log-in(.:format)                                        customers/sessions#new {:kind=>/normal|adult/, :locale=>"nl"}
#                    new_customer_session_en GET    /en(/:kind)/my-account/log-in(.:format)                                          customers/sessions#new {:kind=>/normal|adult/, :locale=>"en"}
#                        customer_session_fr POST   /fr(/:kind)/mon-compte/connectez-vous(.:format)                                  customers/sessions#create {:kind=>/normal|adult/, :locale=>"fr"}
#                        customer_session_nl POST   /nl(/:kind)/mijn-account/log-in(.:format)                                        customers/sessions#create {:kind=>/normal|adult/, :locale=>"nl"}
#                        customer_session_en POST   /en(/:kind)/my-account/log-in(.:format)                                          customers/sessions#create {:kind=>/normal|adult/, :locale=>"en"}
#                destroy_customer_session_fr DELETE /fr(/:kind)/mon-compte/sign_out(.:format)                                        customers/sessions#destroy {:kind=>/normal|adult/, :locale=>"fr"}
#                destroy_customer_session_nl DELETE /nl(/:kind)/mijn-account/sign_out(.:format)                                      customers/sessions#destroy {:kind=>/normal|adult/, :locale=>"nl"}
#                destroy_customer_session_en DELETE /en(/:kind)/my-account/sign_out(.:format)                                        customers/sessions#destroy {:kind=>/normal|adult/, :locale=>"en"}
#                       customer_password_fr POST   /fr(/:kind)/mon-compte/password(.:format)                                        devise/passwords#create {:kind=>/normal|adult/, :locale=>"fr"}
#                       customer_password_nl POST   /nl(/:kind)/mijn-account/password(.:format)                                      devise/passwords#create {:kind=>/normal|adult/, :locale=>"nl"}
#                       customer_password_en POST   /en(/:kind)/my-account/password(.:format)                                        devise/passwords#create {:kind=>/normal|adult/, :locale=>"en"}
#                   new_customer_password_fr GET    /fr(/:kind)/mon-compte/password/nouveau(.:format)                                devise/passwords#new {:kind=>/normal|adult/, :locale=>"fr"}
#                   new_customer_password_nl GET    /nl(/:kind)/mijn-account/password/nieuw(.:format)                                devise/passwords#new {:kind=>/normal|adult/, :locale=>"nl"}
#                   new_customer_password_en GET    /en(/:kind)/my-account/password/new(.:format)                                    devise/passwords#new {:kind=>/normal|adult/, :locale=>"en"}
#                  edit_customer_password_fr GET    /fr(/:kind)/mon-compte/password/edit(.:format)                                   devise/passwords#edit {:kind=>/normal|adult/, :locale=>"fr"}
#                  edit_customer_password_nl GET    /nl(/:kind)/mijn-account/password/edit(.:format)                                 devise/passwords#edit {:kind=>/normal|adult/, :locale=>"nl"}
#                  edit_customer_password_en GET    /en(/:kind)/my-account/password/edit(.:format)                                   devise/passwords#edit {:kind=>/normal|adult/, :locale=>"en"}
#                                            PUT    /fr(/:kind)/mon-compte/password(.:format)                                        devise/passwords#update {:kind=>/normal|adult/, :locale=>"fr"}
#                                            PUT    /nl(/:kind)/mijn-account/password(.:format)                                      devise/passwords#update {:kind=>/normal|adult/, :locale=>"nl"}
#                                            PUT    /en(/:kind)/my-account/password(.:format)                                        devise/passwords#update {:kind=>/normal|adult/, :locale=>"en"}
#            cancel_customer_registration_fr GET    /fr(/:kind)/mon-compte/cancel(.:format)                                          customers/registrations#cancel {:kind=>/normal|adult/, :locale=>"fr"}
#            cancel_customer_registration_nl GET    /nl(/:kind)/mijn-account/cancel(.:format)                                        customers/registrations#cancel {:kind=>/normal|adult/, :locale=>"nl"}
#            cancel_customer_registration_en GET    /en(/:kind)/my-account/cancel(.:format)                                          customers/registrations#cancel {:kind=>/normal|adult/, :locale=>"en"}
#                   customer_registration_fr POST   /fr(/:kind)/mon-compte(.:format)                                                 customers/registrations#create {:kind=>/normal|adult/, :locale=>"fr"}
#                   customer_registration_nl POST   /nl(/:kind)/mijn-account(.:format)                                               customers/registrations#create {:kind=>/normal|adult/, :locale=>"nl"}
#                   customer_registration_en POST   /en(/:kind)/my-account(.:format)                                                 customers/registrations#create {:kind=>/normal|adult/, :locale=>"en"}
#               new_customer_registration_fr GET    /fr(/:kind)/mon-compte/sign_up(.:format)                                         customers/registrations#new {:kind=>/normal|adult/, :locale=>"fr"}
#               new_customer_registration_nl GET    /nl(/:kind)/mijn-account/sign_up(.:format)                                       customers/registrations#new {:kind=>/normal|adult/, :locale=>"nl"}
#               new_customer_registration_en GET    /en(/:kind)/my-account/sign_up(.:format)                                         customers/registrations#new {:kind=>/normal|adult/, :locale=>"en"}
#              edit_customer_registration_fr GET    /fr(/:kind)/mon-compte/edit(.:format)                                            customers/registrations#edit {:kind=>/normal|adult/, :locale=>"fr"}
#              edit_customer_registration_nl GET    /nl(/:kind)/mijn-account/edit(.:format)                                          customers/registrations#edit {:kind=>/normal|adult/, :locale=>"nl"}
#              edit_customer_registration_en GET    /en(/:kind)/my-account/edit(.:format)                                            customers/registrations#edit {:kind=>/normal|adult/, :locale=>"en"}
#                                            PUT    /fr(/:kind)/mon-compte(.:format)                                                 customers/registrations#update {:kind=>/normal|adult/, :locale=>"fr"}
#                                            PUT    /nl(/:kind)/mijn-account(.:format)                                               customers/registrations#update {:kind=>/normal|adult/, :locale=>"nl"}
#                                            PUT    /en(/:kind)/my-account(.:format)                                                 customers/registrations#update {:kind=>/normal|adult/, :locale=>"en"}
#                                            DELETE /fr(/:kind)/mon-compte(.:format)                                                 customers/registrations#destroy {:kind=>/normal|adult/, :locale=>"fr"}
#                                            DELETE /nl(/:kind)/mijn-account(.:format)                                               customers/registrations#destroy {:kind=>/normal|adult/, :locale=>"nl"}
#                                            DELETE /en(/:kind)/my-account(.:format)                                                 customers/registrations#destroy {:kind=>/normal|adult/, :locale=>"en"}
#                   customer_confirmation_fr POST   /fr(/:kind)/mon-compte/confirmation(.:format)                                    customers/confirmations#create {:kind=>/normal|adult/, :locale=>"fr"}
#                   customer_confirmation_nl POST   /nl(/:kind)/mijn-account/confirmation(.:format)                                  customers/confirmations#create {:kind=>/normal|adult/, :locale=>"nl"}
#                   customer_confirmation_en POST   /en(/:kind)/my-account/confirmation(.:format)                                    customers/confirmations#create {:kind=>/normal|adult/, :locale=>"en"}
#               new_customer_confirmation_fr GET    /fr(/:kind)/mon-compte/confirmation/nouveau(.:format)                            customers/confirmations#new {:kind=>/normal|adult/, :locale=>"fr"}
#               new_customer_confirmation_nl GET    /nl(/:kind)/mijn-account/confirmation/nieuw(.:format)                            customers/confirmations#new {:kind=>/normal|adult/, :locale=>"nl"}
#               new_customer_confirmation_en GET    /en(/:kind)/my-account/confirmation/new(.:format)                                customers/confirmations#new {:kind=>/normal|adult/, :locale=>"en"}
#                                            GET    /fr(/:kind)/mon-compte/confirmation(.:format)                                    customers/confirmations#show {:kind=>/normal|adult/, :locale=>"fr"}
#                                            GET    /nl(/:kind)/mijn-account/confirmation(.:format)                                  customers/confirmations#show {:kind=>/normal|adult/, :locale=>"nl"}
#                                            GET    /en(/:kind)/my-account/confirmation(.:format)                                    customers/confirmations#show {:kind=>/normal|adult/, :locale=>"en"}
#                     customer_newsletter_fr        /fr(/:kind)/mon-compte/:customer_id/newsletter(.:format)                         customers#newsletter {:kind=>/normal|adult/, :locale=>"fr"}
#                     customer_newsletter_nl        /nl(/:kind)/mijn-account/:customer_id/newsletter(.:format)                       customers#newsletter {:kind=>/normal|adult/, :locale=>"nl"}
#                     customer_newsletter_en        /en(/:kind)/my-account/:customer_id/newsletter(.:format)                         customers#newsletter {:kind=>/normal|adult/, :locale=>"en"}
#                      customer_addresses_fr POST   /fr(/:kind)/mon-compte/:customer_id/addresses(.:format)                          addresses#create {:kind=>/normal|adult/, :locale=>"fr"}
#                      customer_addresses_nl POST   /nl(/:kind)/mijn-account/:customer_id/addresses(.:format)                        addresses#create {:kind=>/normal|adult/, :locale=>"nl"}
#                      customer_addresses_en POST   /en(/:kind)/my-account/:customer_id/addresses(.:format)                          addresses#create {:kind=>/normal|adult/, :locale=>"en"}
#                 edit_customer_addresses_fr GET    /fr(/:kind)/mon-compte/:customer_id/addresses/edit(.:format)                     addresses#edit {:kind=>/normal|adult/, :locale=>"fr"}
#                 edit_customer_addresses_nl GET    /nl(/:kind)/mijn-account/:customer_id/addresses/edit(.:format)                   addresses#edit {:kind=>/normal|adult/, :locale=>"nl"}
#                 edit_customer_addresses_en GET    /en(/:kind)/my-account/:customer_id/addresses/edit(.:format)                     addresses#edit {:kind=>/normal|adult/, :locale=>"en"}
#                                            PUT    /fr(/:kind)/mon-compte/:customer_id/addresses(.:format)                          addresses#update {:kind=>/normal|adult/, :locale=>"fr"}
#                                            PUT    /nl(/:kind)/mijn-account/:customer_id/addresses(.:format)                        addresses#update {:kind=>/normal|adult/, :locale=>"nl"}
#                                            PUT    /en(/:kind)/my-account/:customer_id/addresses(.:format)                          addresses#update {:kind=>/normal|adult/, :locale=>"en"}
#                     customer_suspension_fr POST   /fr(/:kind)/mon-compte/:customer_id/suspension(.:format)                         suspensions#create {:kind=>/normal|adult/, :locale=>"fr"}
#                     customer_suspension_nl POST   /nl(/:kind)/mijn-account/:customer_id/suspension(.:format)                       suspensions#create {:kind=>/normal|adult/, :locale=>"nl"}
#                     customer_suspension_en POST   /en(/:kind)/my-account/:customer_id/suspension(.:format)                         suspensions#create {:kind=>/normal|adult/, :locale=>"en"}
#                 new_customer_suspension_fr GET    /fr(/:kind)/mon-compte/:customer_id/suspension/nouveau(.:format)                 suspensions#new {:kind=>/normal|adult/, :locale=>"fr"}
#                 new_customer_suspension_nl GET    /nl(/:kind)/mijn-account/:customer_id/suspension/nieuw(.:format)                 suspensions#new {:kind=>/normal|adult/, :locale=>"nl"}
#                 new_customer_suspension_en GET    /en(/:kind)/my-account/:customer_id/suspension/new(.:format)                     suspensions#new {:kind=>/normal|adult/, :locale=>"en"}
#                                            DELETE /fr(/:kind)/mon-compte/:customer_id/suspension(.:format)                         suspensions#destroy {:kind=>/normal|adult/, :locale=>"fr"}
#                                            DELETE /nl(/:kind)/mijn-account/:customer_id/suspension(.:format)                       suspensions#destroy {:kind=>/normal|adult/, :locale=>"nl"}
#                                            DELETE /en(/:kind)/my-account/:customer_id/suspension(.:format)                         suspensions#destroy {:kind=>/normal|adult/, :locale=>"en"}
#                 edit_customer_promotion_fr GET    /fr(/:kind)/mon-compte/:customer_id/promotion/edit(.:format)                     promotions#edit {:kind=>/normal|adult/, :locale=>"fr"}
#                 edit_customer_promotion_nl GET    /nl(/:kind)/mijn-account/:customer_id/promotion/edit(.:format)                   promotions#edit {:kind=>/normal|adult/, :locale=>"nl"}
#                 edit_customer_promotion_en GET    /en(/:kind)/my-account/:customer_id/promotion/edit(.:format)                     promotions#edit {:kind=>/normal|adult/, :locale=>"en"}
#                      customer_promotion_fr GET    /fr(/:kind)/mon-compte/:customer_id/promotion(.:format)                          promotions#show {:kind=>/normal|adult/, :locale=>"fr"}
#                      customer_promotion_nl GET    /nl(/:kind)/mijn-account/:customer_id/promotion(.:format)                        promotions#show {:kind=>/normal|adult/, :locale=>"nl"}
#                      customer_promotion_en GET    /en(/:kind)/my-account/:customer_id/promotion(.:format)                          promotions#show {:kind=>/normal|adult/, :locale=>"en"}
#                         customer_images_fr POST   /fr(/:kind)/mon-compte/:customer_id/images(.:format)                             images#create {:kind=>/normal|adult/, :locale=>"fr"}
#                         customer_images_nl POST   /nl(/:kind)/mijn-account/:customer_id/images(.:format)                           images#create {:kind=>/normal|adult/, :locale=>"nl"}
#                         customer_images_en POST   /en(/:kind)/my-account/:customer_id/images(.:format)                             images#create {:kind=>/normal|adult/, :locale=>"en"}
#           edit_customer_payment_methods_fr GET    /fr(/:kind)/mon-compte/:customer_id/payment_methods/edit(.:format)               payment_methods#edit {:kind=>/normal|adult/, :locale=>"fr"}
#           edit_customer_payment_methods_nl GET    /nl(/:kind)/mijn-account/:customer_id/payment_methods/edit(.:format)             payment_methods#edit {:kind=>/normal|adult/, :locale=>"nl"}
#           edit_customer_payment_methods_en GET    /en(/:kind)/my-account/:customer_id/payment_methods/edit(.:format)               payment_methods#edit {:kind=>/normal|adult/, :locale=>"en"}
#                customer_payment_methods_fr GET    /fr(/:kind)/mon-compte/:customer_id/payment_methods(.:format)                    payment_methods#show {:kind=>/normal|adult/, :locale=>"fr"}
#                customer_payment_methods_nl GET    /nl(/:kind)/mijn-account/:customer_id/payment_methods(.:format)                  payment_methods#show {:kind=>/normal|adult/, :locale=>"nl"}
#                customer_payment_methods_en GET    /en(/:kind)/my-account/:customer_id/payment_methods(.:format)                    payment_methods#show {:kind=>/normal|adult/, :locale=>"en"}
#                                            PUT    /fr(/:kind)/mon-compte/:customer_id/payment_methods(.:format)                    payment_methods#update {:kind=>/normal|adult/, :locale=>"fr"}
#                                            PUT    /nl(/:kind)/mijn-account/:customer_id/payment_methods(.:format)                  payment_methods#update {:kind=>/normal|adult/, :locale=>"nl"}
#                                            PUT    /en(/:kind)/my-account/:customer_id/payment_methods(.:format)                    payment_methods#update {:kind=>/normal|adult/, :locale=>"en"}
#                        customer_reviews_fr GET    /fr(/:kind)/mon-compte/:customer_id/reviews(.:format)                            reviews#index {:kind=>/normal|adult/, :locale=>"fr"}
#                        customer_reviews_nl GET    /nl(/:kind)/mijn-account/:customer_id/reviews(.:format)                          reviews#index {:kind=>/normal|adult/, :locale=>"nl"}
#                        customer_reviews_en GET    /en(/:kind)/my-account/:customer_id/reviews(.:format)                            reviews#index {:kind=>/normal|adult/, :locale=>"en"}
#                               customers_fr GET    /fr(/:kind)/mon-compte(.:format)                                                 customers#index {:kind=>/normal|adult/, :locale=>"fr"}
#                               customers_nl GET    /nl(/:kind)/mijn-account(.:format)                                               customers#index {:kind=>/normal|adult/, :locale=>"nl"}
#                               customers_en GET    /en(/:kind)/my-account(.:format)                                                 customers#index {:kind=>/normal|adult/, :locale=>"en"}
#                                            POST   /fr(/:kind)/mon-compte(.:format)                                                 customers#create {:kind=>/normal|adult/, :locale=>"fr"}
#                                            POST   /nl(/:kind)/mijn-account(.:format)                                               customers#create {:kind=>/normal|adult/, :locale=>"nl"}
#                                            POST   /en(/:kind)/my-account(.:format)                                                 customers#create {:kind=>/normal|adult/, :locale=>"en"}
#                            new_customer_fr GET    /fr(/:kind)/mon-compte/nouveau(.:format)                                         customers#new {:kind=>/normal|adult/, :locale=>"fr"}
#                            new_customer_nl GET    /nl(/:kind)/mijn-account/nieuw(.:format)                                         customers#new {:kind=>/normal|adult/, :locale=>"nl"}
#                            new_customer_en GET    /en(/:kind)/my-account/new(.:format)                                             customers#new {:kind=>/normal|adult/, :locale=>"en"}
#                           edit_customer_fr GET    /fr(/:kind)/mon-compte/:id/edit(.:format)                                        customers#edit {:kind=>/normal|adult/, :locale=>"fr"}
#                           edit_customer_nl GET    /nl(/:kind)/mijn-account/:id/edit(.:format)                                      customers#edit {:kind=>/normal|adult/, :locale=>"nl"}
#                           edit_customer_en GET    /en(/:kind)/my-account/:id/edit(.:format)                                        customers#edit {:kind=>/normal|adult/, :locale=>"en"}
#                                customer_fr GET    /fr(/:kind)/mon-compte/:id(.:format)                                             customers#show {:kind=>/normal|adult/, :locale=>"fr"}
#                                customer_nl GET    /nl(/:kind)/mijn-account/:id(.:format)                                           customers#show {:kind=>/normal|adult/, :locale=>"nl"}
#                                customer_en GET    /en(/:kind)/my-account/:id(.:format)                                             customers#show {:kind=>/normal|adult/, :locale=>"en"}
#                                            PUT    /fr(/:kind)/mon-compte/:id(.:format)                                             customers#update {:kind=>/normal|adult/, :locale=>"fr"}
#                                            PUT    /nl(/:kind)/mijn-account/:id(.:format)                                           customers#update {:kind=>/normal|adult/, :locale=>"nl"}
#                                            PUT    /en(/:kind)/my-account/:id(.:format)                                             customers#update {:kind=>/normal|adult/, :locale=>"en"}
#                                            DELETE /fr(/:kind)/mon-compte/:id(.:format)                                             customers#destroy {:kind=>/normal|adult/, :locale=>"fr"}
#                                            DELETE /nl(/:kind)/mijn-account/:id(.:format)                                           customers#destroy {:kind=>/normal|adult/, :locale=>"nl"}
#                                            DELETE /en(/:kind)/my-account/:id(.:format)                                             customers#destroy {:kind=>/normal|adult/, :locale=>"en"}
#                                    info_fr        /fr(/:kind)/information/:page_name(.:format)                                     info#index {:kind=>/normal|adult/, :locale=>"fr"}
#                                    info_nl        /nl(/:kind)/informatie/:page_name(.:format)                                      info#index {:kind=>/normal|adult/, :locale=>"nl"}
#                                    info_en        /en(/:kind)/information/:page_name(.:format)                                     info#index {:kind=>/normal|adult/, :locale=>"en"}
#               streaming_products_sample_fr        /fr(/:kind)/streaming-film/extrait-video-streaming(.:format)                     streaming_products#sample {:kind=>/normal|adult/, :locale=>"fr"}
#               streaming_products_sample_nl        /nl(/:kind)/film-streaming/video-streaming-fragment(.:format)                    streaming_products#sample {:kind=>/normal|adult/, :locale=>"nl"}
#               streaming_products_sample_en        /en(/:kind)/movie-streaming/video-streaming-fragment(.:format)                   streaming_products#sample {:kind=>/normal|adult/, :locale=>"en"}
#              streaming_product_language_fr        /fr(/:kind)/streaming-film/:streaming_product_id/language(.:format)              streaming_products#language {:kind=>/normal|adult/, :locale=>"fr"}
#              streaming_product_language_nl        /nl(/:kind)/film-streaming/:streaming_product_id/language(.:format)              streaming_products#language {:kind=>/normal|adult/, :locale=>"nl"}
#              streaming_product_language_en        /en(/:kind)/movie-streaming/:streaming_product_id/language(.:format)             streaming_products#language {:kind=>/normal|adult/, :locale=>"en"}
#              streaming_product_subtitle_fr        /fr(/:kind)/streaming-film/:streaming_product_id/subtitle(.:format)              streaming_products#subtitle {:kind=>/normal|adult/, :locale=>"fr"}
#              streaming_product_subtitle_nl        /nl(/:kind)/film-streaming/:streaming_product_id/subtitle(.:format)              streaming_products#subtitle {:kind=>/normal|adult/, :locale=>"nl"}
#              streaming_product_subtitle_en        /en(/:kind)/movie-streaming/:streaming_product_id/subtitle(.:format)             streaming_products#subtitle {:kind=>/normal|adult/, :locale=>"en"}
#              streaming_product_versions_fr        /fr(/:kind)/streaming-film/:streaming_product_id/versions(.:format)              streaming_products#versions {:kind=>/normal|adult/, :locale=>"fr"}
#              streaming_product_versions_nl        /nl(/:kind)/film-streaming/:streaming_product_id/versions(.:format)              streaming_products#versions {:kind=>/normal|adult/, :locale=>"nl"}
#              streaming_product_versions_en        /en(/:kind)/movie-streaming/:streaming_product_id/versions(.:format)             streaming_products#versions {:kind=>/normal|adult/, :locale=>"en"}
#                       streaming_product_fr GET    /fr(/:kind)/streaming-film/:id(.:format)                                         streaming_products#show {:kind=>/normal|adult/, :locale=>"fr"}
#                       streaming_product_nl GET    /nl(/:kind)/film-streaming/:id(.:format)                                         streaming_products#show {:kind=>/normal|adult/, :locale=>"nl"}
#                       streaming_product_en GET    /en(/:kind)/movie-streaming/:id(.:format)                                        streaming_products#show {:kind=>/normal|adult/, :locale=>"en"}
#                                 product_fr GET    /fr(/:kind)/films/:id(.:format)                                                  products#show {:id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"fr"}
#                                 product_nl GET    /nl(/:kind)/films/:id(.:format)                                                  products#show {:id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"nl"}
#                                 product_en GET    /en(/:kind)/movies/:id(.:format)                                                 products#show {:id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"en"}
#                          product_rating_fr POST   /fr(/:kind)/films/:product_id/rating(.:format)                                   ratings#create {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"fr"}
#                          product_rating_nl POST   /nl(/:kind)/films/:product_id/rating(.:format)                                   ratings#create {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"nl"}
#                          product_rating_en POST   /en(/:kind)/movies/:product_id/rating(.:format)                                  ratings#create {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"en"}
#                         product_reviews_fr POST   /fr(/:kind)/films/:product_id/reviews(.:format)                                  reviews#create {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"fr"}
#                         product_reviews_nl POST   /nl(/:kind)/films/:product_id/reviews(.:format)                                  reviews#create {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"nl"}
#                         product_reviews_en POST   /en(/:kind)/movies/:product_id/reviews(.:format)                                 reviews#create {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"en"}
#                      new_product_review_fr GET    /fr(/:kind)/films/:product_id/reviews/nouveau(.:format)                          reviews#new {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"fr"}
#                      new_product_review_nl GET    /nl(/:kind)/films/:product_id/reviews/nieuw(.:format)                            reviews#new {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"nl"}
#                      new_product_review_en GET    /en(/:kind)/movies/:product_id/reviews/new(.:format)                             reviews#new {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"en"}
#                            product_step_fr        /fr(/:kind)/films/:product_id/step(.:format)                                     products#step {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"fr"}
#                            product_step_nl        /nl(/:kind)/films/:product_id/step(.:format)                                     products#step {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"nl"}
#                            product_step_en        /en(/:kind)/movies/:product_id/step(.:format)                                    products#step {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"en"}
#                          product_awards_fr        /fr(/:kind)/films/:product_id/awards(.:format)                                   products#awards {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"fr"}
#                          product_awards_nl        /nl(/:kind)/films/:product_id/awards(.:format)                                   products#awards {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"nl"}
#                          product_awards_en        /en(/:kind)/movies/:product_id/awards(.:format)                                  products#awards {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"en"}
#                            product_seen_fr        /fr(/:kind)/films/:product_id/seen(.:format)                                     products#seen {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"fr"}
#                            product_seen_nl        /nl(/:kind)/films/:product_id/seen(.:format)                                     products#seen {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"nl"}
#                            product_seen_en        /en(/:kind)/movies/:product_id/seen(.:format)                                    products#seen {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"en"}
#                         product_trailer_fr        /fr(/:kind)/films/:product_id/trailer(.:format)                                  products#trailer {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"fr"}
#                         product_trailer_nl        /nl(/:kind)/films/:product_id/trailer(.:format)                                  products#trailer {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"nl"}
#                         product_trailer_en        /en(/:kind)/movies/:product_id/trailer(.:format)                                 products#trailer {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"en"}
#                    product_uninterested_fr        /fr(/:kind)/films/:product_id/uninterested(.:format)                             products#uninterested {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"fr"}
#                    product_uninterested_nl        /nl(/:kind)/films/:product_id/uninterested(.:format)                             products#uninterested {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"nl"}
#                    product_uninterested_en        /en(/:kind)/movies/:product_id/uninterested(.:format)                            products#uninterested {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"en"}
#                          product_action_fr        /fr(/:kind)/films/:product_id/action(.:format)                                   products#action {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"fr"}
#                          product_action_nl        /nl(/:kind)/films/:product_id/action(.:format)                                   products#action {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"nl"}
#                          product_action_en        /en(/:kind)/movies/:product_id/action(.:format)                                  products#action {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"en"}
#                             product_log_fr        /fr(/:kind)/films/:product_id/log(.:format)                                      products#log {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"fr"}
#                             product_log_nl        /nl(/:kind)/films/:product_id/log(.:format)                                      products#log {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"nl"}
#                             product_log_en        /en(/:kind)/movies/:product_id/log(.:format)                                     products#log {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"en"}
#                            product_data_fr        /fr(/:kind)/films/:product_id/data(.:format)                                     products#data {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"fr"}
#                            product_data_nl        /nl(/:kind)/films/:product_id/data(.:format)                                     products#data {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"nl"}
#                            product_data_en        /en(/:kind)/movies/:product_id/data(.:format)                                    products#data {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"en"}
#                         product_sign_up_fr        /fr(/:kind)/films/:product_id/sign_up(.:format)                                  products#sign_up {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"fr"}
#                         product_sign_up_nl        /nl(/:kind)/films/:product_id/sign_up(.:format)                                  products#sign_up {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"nl"}
#                         product_sign_up_en        /en(/:kind)/movies/:product_id/sign_up(.:format)                                 products#sign_up {:product_id=>/[0-9]+[0-9a-zA-Z\-_]*/, :kind=>/normal|adult/, :locale=>"en"}
#                          products_short_fr        /fr(/:kind)/films(/:package)(/:view_mode)(.:format)                              products#index {:kind=>/normal|adult/, :locale=>"fr"}
#                          products_short_nl        /nl(/:kind)/films(/:package)(/:view_mode)(.:format)                              products#index {:kind=>/normal|adult/, :locale=>"nl"}
#                          products_short_en        /en(/:kind)/movies(/:package)(/:view_mode)(.:format)                             products#index {:kind=>/normal|adult/, :locale=>"en"}
#                          phone_requests_fr GET    /fr(/:kind)/contact(.:format)                                                    phone_requests#index {:kind=>/normal|adult/, :locale=>"fr"}
#                          phone_requests_nl GET    /nl(/:kind)/contact(.:format)                                                    phone_requests#index {:kind=>/normal|adult/, :locale=>"nl"}
#                          phone_requests_en GET    /en(/:kind)/contact(.:format)                                                    phone_requests#index {:kind=>/normal|adult/, :locale=>"en"}
#                                            POST   /fr(/:kind)/contact(.:format)                                                    phone_requests#create {:kind=>/normal|adult/, :locale=>"fr"}
#                                            POST   /nl(/:kind)/contact(.:format)                                                    phone_requests#create {:kind=>/normal|adult/, :locale=>"nl"}
#                                            POST   /en(/:kind)/contact(.:format)                                                    phone_requests#create {:kind=>/normal|adult/, :locale=>"en"}
#                       new_phone_request_fr GET    /fr(/:kind)/contact/nouveau(.:format)                                            phone_requests#new {:kind=>/normal|adult/, :locale=>"fr"}
#                       new_phone_request_nl GET    /nl(/:kind)/contact/nieuw(.:format)                                              phone_requests#new {:kind=>/normal|adult/, :locale=>"nl"}
#                       new_phone_request_en GET    /en(/:kind)/contact/new(.:format)                                                phone_requests#new {:kind=>/normal|adult/, :locale=>"en"}
#                          actor_products_fr GET    /fr(/:kind)/acteur/:actor_id/films(.:format)                                     products#index {:kind=>/normal|adult/, :locale=>"fr", :concerns=>:productable}
#                          actor_products_nl GET    /nl(/:kind)/acteur/:actor_id/films(.:format)                                     products#index {:kind=>/normal|adult/, :locale=>"nl", :concerns=>:productable}
#                          actor_products_en GET    /en(/:kind)/actor/:actor_id/movies(.:format)                                     products#index {:kind=>/normal|adult/, :locale=>"en", :concerns=>:productable}
#                                  actors_fr GET    /fr(/:kind)/acteur(.:format)                                                     actors#index {:kind=>/normal|adult/, :locale=>"fr", :concerns=>:productable}
#                                  actors_nl GET    /nl(/:kind)/acteur(.:format)                                                     actors#index {:kind=>/normal|adult/, :locale=>"nl", :concerns=>:productable}
#                                  actors_en GET    /en(/:kind)/actor(.:format)                                                      actors#index {:kind=>/normal|adult/, :locale=>"en", :concerns=>:productable}
#                       director_products_fr GET    /fr(/:kind)/realisateur/:director_id/films(.:format)                             products#index {:kind=>/normal|adult/, :locale=>"fr", :concerns=>:productable}
#                       director_products_nl GET    /nl(/:kind)/regisseur/:director_id/films(.:format)                               products#index {:kind=>/normal|adult/, :locale=>"nl", :concerns=>:productable}
#                       director_products_en GET    /en(/:kind)/director/:director_id/movies(.:format)                               products#index {:kind=>/normal|adult/, :locale=>"en", :concerns=>:productable}
#                                  freetrial        /:locale(/:kind)/freetrial(.:format)                                             freetrial#plans {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                   photobox        /:locale(/:kind)/photobox(.:format)                                              photobox#plans {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                  carrefour        /:locale(/:kind)/carrefour(.:format)                                             home#carrefour {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                    belgium        /:locale(/:kind)/belgium(.:format)                                               home#belgium {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                      edit_public_promotion GET    /:locale(/:kind)/public_promotion/edit(.:format)                                 public_promotions#edit {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                           public_promotion PUT    /:locale(/:kind)/public_promotion(.:format)                                      public_promotions#update {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                              root_localize        /:locale(/:kind)(.:format)                                                       products#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                 validation        /:locale(/:kind)/validation(.:format)                                            home#validation {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                         customers_reactive        /:locale(/:kind)/customers/reactive(.:format)                                    customers#reactive {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                        customers_promotion        /:locale(/:kind)/customers/promotion(.:format)                                   customers#promotion {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#         new_old_customers_customer_session GET    /:locale(/:kind)/customers/sign_in(.:format)                                     devise/sessions#new {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#             old_customers_customer_session POST   /:locale(/:kind)/customers/sign_in(.:format)                                     devise/sessions#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#     destroy_old_customers_customer_session DELETE /:locale(/:kind)/customers/sign_out(.:format)                                    devise/sessions#destroy {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#            old_customers_customer_password POST   /:locale(/:kind)/customers/password(.:format)                                    devise/passwords#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#        new_old_customers_customer_password GET    /:locale(/:kind)/customers/password/new(.:format)                                devise/passwords#new {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#       edit_old_customers_customer_password GET    /:locale(/:kind)/customers/password/edit(.:format)                               devise/passwords#edit {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            PUT    /:locale(/:kind)/customers/password(.:format)                                    devise/passwords#update {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
# cancel_old_customers_customer_registration GET    /:locale(/:kind)/customers/cancel(.:format)                                      customers/registrations#cancel {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#        old_customers_customer_registration POST   /:locale(/:kind)/customers(.:format)                                             customers/registrations#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#    new_old_customers_customer_registration GET    /:locale(/:kind)/customers/sign_up(.:format)                                     customers/registrations#new {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#   edit_old_customers_customer_registration GET    /:locale(/:kind)/customers/edit(.:format)                                        customers/registrations#edit {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            PUT    /:locale(/:kind)/customers(.:format)                                             customers/registrations#update {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            DELETE /:locale(/:kind)/customers(.:format)                                             customers/registrations#destroy {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#        old_customers_customer_confirmation POST   /:locale(/:kind)/customers/confirmation(.:format)                                customers/confirmations#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#    new_old_customers_customer_confirmation GET    /:locale(/:kind)/customers/confirmation/new(.:format)                            customers/confirmations#new {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            GET    /:locale(/:kind)/customers/confirmation(.:format)                                customers/confirmations#show {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                    old_customer_newsletter        /:locale(/:kind)/customers/:old_customer_id/newsletter(.:format)                 customers#newsletter {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                     old_customer_addresses POST   /:locale(/:kind)/customers/:old_customer_id/addresses(.:format)                  addresses#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                edit_old_customer_addresses GET    /:locale(/:kind)/customers/:old_customer_id/addresses/edit(.:format)             addresses#edit {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            PUT    /:locale(/:kind)/customers/:old_customer_id/addresses(.:format)                  addresses#update {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                    old_customer_suspension POST   /:locale(/:kind)/customers/:old_customer_id/suspension(.:format)                 suspensions#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                new_old_customer_suspension GET    /:locale(/:kind)/customers/:old_customer_id/suspension/new(.:format)             suspensions#new {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            DELETE /:locale(/:kind)/customers/:old_customer_id/suspension(.:format)                 suspensions#destroy {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                edit_old_customer_promotion GET    /:locale(/:kind)/customers/:old_customer_id/promotion/edit(.:format)             promotions#edit {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                     old_customer_promotion GET    /:locale(/:kind)/customers/:old_customer_id/promotion(.:format)                  promotions#show {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                        old_customer_images POST   /:locale(/:kind)/customers/:old_customer_id/images(.:format)                     images#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#          edit_old_customer_payment_methods GET    /:locale(/:kind)/customers/:old_customer_id/payment_methods/edit(.:format)       payment_methods#edit {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#               old_customer_payment_methods GET    /:locale(/:kind)/customers/:old_customer_id/payment_methods(.:format)            payment_methods#show {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            PUT    /:locale(/:kind)/customers/:old_customer_id/payment_methods(.:format)            payment_methods#update {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                       old_customer_reviews GET    /:locale(/:kind)/customers/:old_customer_id/reviews(.:format)                    reviews#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                         old_customer_index GET    /:locale(/:kind)/customers(.:format)                                             customers#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            POST   /:locale(/:kind)/customers(.:format)                                             customers#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                           new_old_customer GET    /:locale(/:kind)/customers/new(.:format)                                         customers#new {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                          edit_old_customer GET    /:locale(/:kind)/customers/:id/edit(.:format)                                    customers#edit {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                               old_customer GET    /:locale(/:kind)/customers/:id(.:format)                                         customers#show {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            PUT    /:locale(/:kind)/customers/:id(.:format)                                         customers#update {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            DELETE /:locale(/:kind)/customers/:id(.:format)                                         customers#destroy {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                   info_old        /:locale(/:kind)/info/:page_name(.:format)                                       info#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                         old_product_rating POST   /:locale(/:kind)/products/:old_product_id/rating(.:format)                       ratings#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                        old_product_reviews POST   /:locale(/:kind)/products/:old_product_id/reviews(.:format)                      reviews#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                     new_old_product_review GET    /:locale(/:kind)/products/:old_product_id/reviews/new(.:format)                  reviews#new {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                         old_product_tokens POST   /:locale(/:kind)/products/:old_product_id/tokens(.:format)                       tokens#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                      new_old_product_token GET    /:locale(/:kind)/products/:old_product_id/tokens/new(.:format)                   tokens#new {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                         old_product_awards        /:locale(/:kind)/products/:old_product_id/awards(.:format)                       products#awards {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                           old_product_seen        /:locale(/:kind)/products/:old_product_id/seen(.:format)                         products#seen {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                        old_product_trailer        /:locale(/:kind)/products/:old_product_id/trailer(.:format)                      products#trailer {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                   old_product_uninterested        /:locale(/:kind)/products/:old_product_id/uninterested(.:format)                 products#uninterested {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                         old_product_action        /:locale(/:kind)/products/:old_product_id/action(.:format)                       products#action {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                            old_product_log        /:locale(/:kind)/products/:old_product_id/log(.:format)                          products#log {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                               old_products GET    /:locale(/:kind)/products(.:format)                                              products#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                old_product GET    /:locale(/:kind)/products/:id(.:format)                                          products#show {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                         old_phone_requests GET    /:locale(/:kind)/phone_requests(.:format)                                        phone_requests#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            POST   /:locale(/:kind)/phone_requests(.:format)                                        phone_requests#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                      new_old_phone_request GET    /:locale(/:kind)/phone_requests/new(.:format)                                    phone_requests#new {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                     search        /:locale(/:kind)/search(/:search)(.:format)                                      search#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                         public_newsletters POST   /:locale(/:kind)/public_newsletters(.:format)                                    public_newsletters#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                      new_public_newsletter GET    /:locale(/:kind)/public_newsletters/new(.:format)                                public_newsletters#new {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                       review_review_rating POST   /:locale(/:kind)/reviews/:review_id/review_rating(.:format)                      review_ratings#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                     review GET    /:locale(/:kind)/reviews/:id(.:format)                                           reviews#show {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                            messages_urgent        /:locale(/:kind)/messages/urgent(.:format)                                       messages#urgent {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                   messages GET    /:locale(/:kind)/messages(.:format)                                              messages#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            POST   /:locale(/:kind)/messages(.:format)                                              messages#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                new_message GET    /:locale(/:kind)/messages/new(.:format)                                          messages#new {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                               edit_message GET    /:locale(/:kind)/messages/:id/edit(.:format)                                     messages#edit {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                    message GET    /:locale(/:kind)/messages/:id(.:format)                                          messages#show {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            PUT    /:locale(/:kind)/messages/:id(.:format)                                          messages#update {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            DELETE /:locale(/:kind)/messages/:id(.:format)                                          messages#destroy {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                     ticket_message_tickets POST   /:locale(/:kind)/tickets/:ticket_id/message_tickets(.:format)                    message_tickets#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                    tickets GET    /:locale(/:kind)/tickets(.:format)                                               tickets#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            POST   /:locale(/:kind)/tickets(.:format)                                               tickets#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                 new_ticket GET    /:locale(/:kind)/tickets/new(.:format)                                           tickets#new {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                edit_ticket GET    /:locale(/:kind)/tickets/:id/edit(.:format)                                      tickets#edit {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                     ticket GET    /:locale(/:kind)/tickets/:id(.:format)                                           tickets#show {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            PUT    /:locale(/:kind)/tickets/:id(.:format)                                           tickets#update {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            DELETE /:locale(/:kind)/tickets/:id(.:format)                                           tickets#destroy {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                  promotion GET    /:locale(/:kind)/promotions/:id(.:format)                                        promotions#show {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                            promotion_canva POST   /:locale(/:kind)/promotions/:id(.:format)                                        promotions#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                               subscription PUT    /:locale(/:kind)/subscription(.:format)                                          subscriptions#update {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                          category_products GET    /:locale(/:kind)/categories/:category_id/products(.:format)                      products#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/, :concerns=>:productable}
#                                 categories GET    /:locale(/:kind)/categories(.:format)                                            categories#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/, :concerns=>:productable}
#                         old_actor_products GET    /:locale(/:kind)/actors/:old_actor_id/products(.:format)                         products#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/, :concerns=>:productable}
#                                 old_actors GET    /:locale(/:kind)/actors(.:format)                                                actors#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/, :concerns=>:productable}
#                      old_director_products GET    /:locale(/:kind)/directors/:old_director_id/products(.:format)                   products#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/, :concerns=>:productable}
#                            studio_products GET    /:locale(/:kind)/studios/:studio_id/products(.:format)                           products#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/, :concerns=>:productable}
#                                    studios GET    /:locale(/:kind)/studios(.:format)                                               studios#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/, :concerns=>:productable}
#                                        faq GET    /:locale(/:kind)/faq(.:format)                                                   messages#faq {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                       step GET    /:locale(/:kind)/steps/:id(.:format)                                             steps#show {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            PUT    /:locale(/:kind)/steps/:id(.:format)                                             steps#update {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                              vod_wishlists GET    /:locale(/:kind)/watchlists(.:format)                                            watchlists#index {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            POST   /:locale(/:kind)/watchlists(.:format)                                            watchlists#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                           new_vod_wishlist GET    /:locale(/:kind)/watchlists/new(.:format)                                        watchlists#new {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                          edit_vod_wishlist GET    /:locale(/:kind)/watchlists/:id/edit(.:format)                                   watchlists#edit {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                               vod_wishlist GET    /:locale(/:kind)/watchlists/:id(.:format)                                        watchlists#show {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            PUT    /:locale(/:kind)/watchlists/:id(.:format)                                        watchlists#update {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            DELETE /:locale(/:kind)/watchlists/:id(.:format)                                        watchlists#destroy {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                display_vod        /:locale(/:kind)/display_vod(.:format)                                           watchlists#display_vod {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                             search_filters PUT    /:locale(/:kind)/search_filters(.:format)                                        search_filters#update {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                            DELETE /:locale(/:kind)/search_filters(.:format)                                        search_filters#destroy {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#              old_streaming_products_sample        /:locale(/:kind)/streaming_products/sample(.:format)                             streaming_products#sample {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#             old_streaming_product_language        /:locale(/:kind)/streaming_products/:old_streaming_product_id/language(.:format) streaming_products#language {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#             old_streaming_product_subtitle        /:locale(/:kind)/streaming_products/:old_streaming_product_id/subtitle(.:format) streaming_products#subtitle {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#             old_streaming_product_versions        /:locale(/:kind)/streaming_products/:old_streaming_product_id/versions(.:format) streaming_products#versions {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                      old_streaming_product GET    /:locale(/:kind)/streaming_products/:id(.:format)                                streaming_products#show {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                                unsubscribe GET    /:locale(/:kind)/unsubscribe(.:format)                                           customers#unsubscribe {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                               back_to_tvod GET    /:locale(/:kind)/back_to_tvod(.:format)                                          customers#back_to_tvod {:locale=>/en|fr|nl/, :kind=>/normal|adult/}
#                         promotion_localize GET    /:locale(/:kind)/:id(.:format)                                                   promotions#show {:locale=>/en|fr|nl/, :kind=>/normal|adult/, :id=>/samsung|promotion/}
#                         promotion_localize POST   /:locale(/:kind)/:id(.:format)                                                   promotions#create {:locale=>/en|fr|nl/, :kind=>/normal|adult/, :id=>/samsung|promotion/}
#                            short_promotion GET    /:id(.:format)                                                                   promotions#show {:id=>/smarttv|radio_contact|samsung|nostalgie|playstation/, :format=>"choose"}
#                            short_promotion POST   /:id(.:format)                                                                   promotions#show {:id=>/smarttv|radio_contact|samsung|nostalgie/, :format=>"choose"}
#                             root_promotion GET    /promotions/:id(.:format)                                                        promotions#show {:format=>"choose"}
#                                                   /404(.:format)                                                                   errors#not_found
#                                                   /500(.:format)                                                                   errors#not_found
#                               rails_routes GET    /rails/routes(.:format)                                                          sextant/routes#index
#                             sextant_engine        /sextant                                                                         Sextant::Engine
#
# Routes for Sextant::Engine:
#

Moovies::Application.routes.draw do

  get "carrefourbonus/plans"

  concern :productable do
    resources :products, :only => :index
  end

  root :to => 'products#index'
  resource :ogone, :only => [:create]
  resource :home_products, :only => [:update, :edit]
  resource :list, :only => [:new, :create]

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
  scope ':locale/(:kind)', :locale => /en|fr|nl/, :kind => /normal|adult/ do
    match "freetrial" => "freetrial#plans"
    match "photobox" => "photobox#plans"
    match 'carrefour' => 'home#carrefour'
    match 'belgium' => "home#belgium"
    resource :public_promotion, :only => [:edit, :update]
    match "/" => 'products#index', :as => :root_localize
    match "validation" => 'home#validation'
    match 'customers/reactive' => "customers#reactive"
    match 'customers/promotion' => "customers#promotion"
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
