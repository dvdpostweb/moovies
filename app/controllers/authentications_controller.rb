class AuthenticationsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    params = request.env["omniauth.params"]
    code = params["code"]
    authentication = Authentication.find_by_provider_and_uid_and_email(auth['provider'], auth['uid'], auth['extra']['raw_info']['email'])
    user = Customer.find_by_email(auth['extra']['raw_info']['email'])
    if authentication.present?
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:customer, authentication.customer)
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
                  auth.customer.customers_registration_step = 100
                  auth.customer.activation_discount_code_type = 'A'
                  auth.customer.activation_discount_code_id = r["activation_id"]
                  auth.customer.customers_abo_type = r["activation_products_id"]
                  auth.customer.customers_next_abo_type = r["next_abo_type"]
                  auth.customer.group_id = r["activation_group"]
                  auth.customer.customers_next_discount_code = r["next_discount"]
                  if auth.customer.customers_abo_type == 6
                    auth.customer.tvod_free = auth.customer.tvod_free + r["tvod_free"]
                  else
                    auth.customer.tvod_free = r["tvod_free"]
                  end
                  if auth.customer.save(:validate => false)
                    flash[:notice] = t('.social.network.fbconnect.registration.new')
                    sign_in_and_redirect(:customer, auth.customer)
                  else
                    flash[:error] = "Error while creating a user account. Please try again."
                    redirect_to root_url
                  end
                end
              end

              if dresold.present?
                dresold.each do |r|
                  auth.customer.customers_registration_step = r["goto_step"]
                  auth.customer.activation_discount_code_type = 'D'
                  auth.customer.activation_discount_code_id = r["discount_code_id"]
                  auth.customer.customers_abo_type = r["listing_products_allowed"]
                  auth.customer.customers_next_abo_type = r["next_abo_type"]
                  auth.customer.group_id = r["group_id"]
                  if auth.customer.customers_abo_type == 6
                    auth.customer.tvod_free = auth.customer.tvod_free + r["tvod_free"]
                  else
                    auth.customer.tvod_free = r["tvod_free"]
                  end
                  if auth.customer.save(:validate => false)
                    flash[:notice] = t('.social.network.fbconnect.registration.new')
                    sign_in_and_redirect(:customer, auth.customer)
                  else
                    flash[:error] = "Error while creating a user account. Please try again."
                    redirect_to root_url
                  end
                end
              end

            else  
              sign_in_and_redirect(:customer, auth.customer)
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
              if customer.save(:validate => false)
                flash[:notice] = t('.social.network.fbconnect.registration.new')
                sign_in_and_redirect(:customer, customer)
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
              if customer.save(:validate => false)
                flash[:notice] = t('.social.network.fbconnect.registration.new')
                sign_in_and_redirect(:customer, customer)
              else
                flash[:error] = "Error while creating a user account. Please try again."
                redirect_to root_url
              end
            end
          end

        end

        if !code.present?
          discount_code_default = "6FILMSFREE"
          discount_default = Discount.by_name(discount_code_default).available.first 
          if discount_default.present?
            customer.tvod_free = discount_default.tvod_free
            customer.step = discount_default.goto_step
            customer.code = code
          end
          if customer.save(:validate => false)
            flash[:notice] = t('.social.network.fbconnect.registration.new')
            sign_in_and_redirect(:customer, customer)
          else
            flash[:error] = "Error while creating a user account. Please try again."
            redirect_to root_url
          end
        end

      end
    end
  end
end
