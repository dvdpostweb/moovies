class AuthenticationsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    params = request.env["omniauth.params"]
    code = params["code"]
    moovie_id = params["moovie_id"]
    authentication = Authentication.find_by_provider_and_uid_and_email(auth['provider'], auth['uid'], auth['extra']['raw_info']['email'])
    user = Customer.find_by_email(auth['extra']['raw_info']['email'])
    if authentication.present?

      if code.present?

        aqueryold = <<-SQL
        SELECT activation_id, activation_products_id, next_abo_type, activation_group, next_discount, tvod_free
        FROM activation_code
        WHERE activation_code='#{code}'
        SQL
        aresold = ActiveRecord::Base.connection.exec_query(aqueryold)

        dqueryold = <<-SQL
        SELECT discount_code_id, listing_products_allowed, next_abo_type, group_id, tvod_free, goto_step
        FROM discount_code
        WHERE discount_code='#{code}'
        SQL
        dresold = ActiveRecord::Base.connection.exec_query(dqueryold)

        if aresold.present?
          aresold.each do |r|
            user.customers_registration_step = 100
            user.activation_discount_code_type = 'A'
            user.activation_discount_code_id = r["activation_id"]
            user.customers_abo_type = r["activation_products_id"]
            user.customers_next_abo_type = r["next_abo_type"]
            user.group_id = r["activation_group"]
            user.customers_next_discount_code = r["next_discount"]
            #if user.customers_abo_type == 6
            user.tvod_free = user.tvod_free + r["tvod_free"]
            #else
            #  user.tvod_free = r["tvod_free"]
            #end
            user.customers_abo = 1
            if user.save(:validate => false)
              cookies[:customer_identificator] = "#{user.social_network_tag}_customer_identificator"
              activation = Activation.find_by_activation_code(code)
              activation.update_attributes(:customers_id => user.to_param, :created_at => Time.now.localtime)
              #flash[:notice] = t('.social.network.fbconnect.registration.new')
              sign_in(:customer, authentication.customer)
              redirect_to root_path
            else
              flash[:error] = "Error while creating a user account. Please try again."
              redirect_to root_url
            end
          end
        end

        if dresold.present?
          dresold.each do |r|
            user.customers_registration_step = r["goto_step"]
            user.activation_discount_code_type = 'D'
            user.activation_discount_code_id = r["discount_code_id"]
            user.customers_abo_type = r["listing_products_allowed"]
            user.customers_next_abo_type = r["next_abo_type"]
            user.group_id = r["group_id"]
            #if user.customers_abo_type == 6
            user.tvod_free = user.tvod_free + r["tvod_free"]
            #else
            #  user.tvod_free = r["tvod_free"]
            #end
            user.customers_abo = 1
            if user.save(:validate => false)
              cookies[:customer_identificator] = "#{user.social_network_tag}_customer_identificator"
              DiscountUse.create(:discount_code_id => r["discount_code_id"], :customer_id => user.to_param, :discount_use_date => Time.now)
              #flash[:notice] = t('.social.network.fbconnect.registration.new')
              sign_in(:customer, authentication.customer)
              redirect_to root_path
            else
              flash[:error] = "Error while creating a user account. Please try again."
              redirect_to root_url
            end
          end
        end

      else

        cookies[:customer_identificator] = "#{user.social_network_tag}_customer_identificator"

        product = Product.where(:products_id  => moovie_id).first

        if product
          sign_in(:customer, authentication.customer)
          redirect_to product_path(:id => product.to_param)
        else
          sign_in(:customer, authentication.customer)
          redirect_to root_path
        end

      end

    else
      if user.present?
        flash[:notice] = "Signed in successfully."
        new_auth = Authentication.new
        new_auth.customer_id = user.customers_id
        new_auth.provider = auth['provider']
        new_auth.uid = auth['uid']
        new_auth.token = auth['credentials']['token']
        #############################################################
        ## If token expired update with new token from facebook!!!
        #############################################################
        new_auth.email = auth['extra']['raw_info']['email']
        if new_auth.save

            auth = Authentication.find_by_provider_and_uid_and_email(auth['provider'], auth['uid'], auth['extra']['raw_info']['email'])


						if code.present?

			        aqueryold = <<-SQL
			        SELECT activation_id, activation_products_id, next_abo_type, activation_group, next_discount, tvod_free
			        FROM activation_code
			        WHERE activation_code='#{code}'
			        SQL
			        aresold = ActiveRecord::Base.connection.exec_query(aqueryold)

			        dqueryold = <<-SQL
			        SELECT discount_code_id, listing_products_allowed, next_abo_type, group_id, tvod_free, goto_step
			        FROM discount_code
			        WHERE discount_code='#{code}'
			        SQL
			        dresold = ActiveRecord::Base.connection.exec_query(dqueryold)

			        if aresold.present?
			          aresold.each do |r|
			            user.customers_registration_step = 100
			            user.activation_discount_code_type = 'A'
			            user.activation_discount_code_id = r["activation_id"]
			            user.customers_abo_type = r["activation_products_id"]
			            user.customers_next_abo_type = r["next_abo_type"]
			            user.group_id = r["activation_group"]
			            user.customers_next_discount_code = r["next_discount"]
			            #if user.customers_abo_type == 6
			            user.tvod_free = user.tvod_free + r["tvod_free"]
			            #else
			            #  user.tvod_free = r["tvod_free"]
			            #end
                  user.customers_abo = 1
			            if user.save(:validate => false)
                    cookies[:customer_identificator] = "#{user.social_network_tag}_customer_identificator"
			              activation = Activation.find_by_activation_code(code)
			              activation.update_attributes(:customers_id => user.to_param, :created_at => Time.now.localtime)
			              #flash[:notice] = t('.social.network.fbconnect.registration.new')
			              sign_in(:customer, auth.customer)
                    redirect_to root_path
			            else
			              flash[:error] = "Error while creating a user account. Please try again."
			              redirect_to root_url
			            end
			          end
			        end

			        if dresold.present?
			          dresold.each do |r|
			            user.customers_registration_step = r["goto_step"]
			            user.activation_discount_code_type = 'D'
			            user.activation_discount_code_id = r["discount_code_id"]
			            user.customers_abo_type = r["listing_products_allowed"]
			            user.customers_next_abo_type = r["next_abo_type"]
			            user.group_id = r["group_id"]
			            #if user.customers_abo_type == 6
			            user.tvod_free = user.tvod_free + r["tvod_free"]
			            #else
			            #  user.tvod_free = r["tvod_free"]
			            #end
                  user.customers_abo = 1
			            if user.save(:validate => false)
                    cookies[:customer_identificator] = "#{user.social_network_tag}_customer_identificator"
			              DiscountUse.create(:discount_code_id => r["discount_code_id"], :customer_id => user.to_param, :discount_use_date => Time.now)
			              #flash[:notice] = t('.social.network.fbconnect.registration.new')
			              sign_in(:customer, auth.customer)
                    redirect_to root_path
			            else
			              flash[:error] = "Error while creating a user account. Please try again."
			              redirect_to root_url
			            end
			          end
			        end

			      else

              cookies[:customer_identificator] = "#{user.social_network_tag}_customer_identificator"

              product = Product.where(:products_id  => moovie_id).first

              if product
                sign_in(:customer, auth.customer)
                redirect_to product_path(:id => product.to_param)
              else
                sign_in(:customer, auth.customer)
                redirect_to root_path
              end

			      end

        end
      else

        customer = Customer.new
        customer.apply_omniauth(auth)

        if code.present?

          aquery = <<-SQL
          SELECT activation_id, activation_products_id, next_abo_type, activation_group, next_discount, tvod_free
          FROM activation_code
          WHERE activation_code='#{code}'
          SQL
          ares = ActiveRecord::Base.connection.exec_query(aquery)

          dquery = <<-SQL
          SELECT discount_code_id, listing_products_allowed, next_abo_type, group_id, tvod_free, goto_step
          FROM discount_code
          WHERE discount_code='#{code}'
          SQL
          dres = ActiveRecord::Base.connection.exec_query(dquery)

          if ares.present?
            ares.each do |r|
              customer.customers_registration_step = 100
              customer.activation_discount_code_type = 'A'
              customer.activation_discount_code_id = r["activation_id"]
              customer.customers_abo_type = r["activation_products_id"]
              customer.customers_next_abo_type = r["next_abo_type"]
              customer.group_id = r["activation_group"]
              customer.customers_next_discount_code = r["next_discount"]
              customer.tvod_free = r["tvod_free"]
              customer.customers_abo = 1
              if customer.save(:validate => false)
                cookies[:customer_identificator] = "#{customer.social_network_tag}_customer_identificator"
                activation = Activation.find_by_activation_code(code)
                activation.update_attributes(:customers_id => customer.to_param, :created_at => Time.now.localtime)
                #flash[:notice] = t('.social.network.fbconnect.registration.new')
                sign_in(:customer, customer)
                redirect_to root_path
              else
                flash[:error] = "Error while creating a user account. Please try again."
                redirect_to root_url
              end
            end
          end

          if dres.present?
            dres.each do |r|
              customer.customers_registration_step = r["goto_step"]
              customer.activation_discount_code_type = 'D'
              customer.activation_discount_code_id = r["discount_code_id"]
              customer.customers_abo_type = r["listing_products_allowed"]
              customer.customers_next_abo_type = r["next_abo_type"]
              customer.group_id = r["group_id"]
              customer.tvod_free = r["tvod_free"]
              customer.customers_abo = 1
              if customer.save(:validate => false)
                cookies[:customer_identificator] = "#{customer.social_network_tag}_customer_identificator"
                DiscountUse.create(:discount_code_id => r["discount_code_id"], :customer_id => customer.to_param, :discount_use_date => Time.now)
                #flash[:notice] = t('.social.network.fbconnect.registration.new')
                sign_in(:customer, customer)
                redirect_to root_path
              else
                flash[:error] = "Error while creating a user account. Please try again."
                redirect_to root_url
              end
            end
          end

        end

        if !code.present?
          customer.customers_abo = 1
          customer.step = 100
          customer.customers_abo_type = 6
          customer.customers_next_abo_type = 6
          customer.customers_abo_validityto = nil
          if customer.save(:validate => false)
            cookies[:customer_identificator] = "#{customer.social_network_tag}_customer_identificator"
            if product
              sign_in(:customer, customer)
              redirect_to product_path(:id => product.to_param)
            else
              sign_in(:customer, customer)
              redirect_to root_path
            end
          else
            flash[:error] = "Error while creating a user account. Please try again."
            redirect_to root_url
          end
        end

      end
    end
  end
end
