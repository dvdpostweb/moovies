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
            user.tvod_free = user.tvod_free + r["tvod_free"]
            user.customers_abo = 1
            if user.save(:validate => false)
              if user.set_privilegies?
                activation = Activation.find_by_activation_code(code)
                user.abo_history(8, user.abo_type_id, activation.to_param)
                activation.update_attributes(:customers_id => user.to_param, :created_at => Time.now.localtime)
                sign_in(:customer, authentication.customer)
                redirect_to root_localize_path
              end
            else
              flash[:error] = "Error while creating a user account. Please try again."
              redirect_to root_url
            end
          end
        end

        if dresold.present?
          discount = Discount.find_by_discount_code(code)

          if !authentication.customer.discount_reuse?(discount.month_before_reuse) && discount.bypass_discountuse == 0
            if params["ACTION_TYPE"].present? && params["ACTION_TYPE"] == "FREETRIAL"
              redirect_to freetrial_action_path(:code => code, :freetrial_action => params["freetrial_action"], :films => params["films"], :price => params["price"], :FT_CODE_RESTRICTION => "FTC_ERROR")
            elsif params["ACTION_TYPE"].present? && params["ACTION_TYPE"] == "NORMAL"
              redirect_to "#{params["ORG_URL"]};DS_CODE_RESTRICTION_ERROR=DISCOUNT_CODE_LIMIT_AUTH_ERROR"
            end
          else
            dresold.each do |r|
              user.customers_registration_step = r["goto_step"]
              user.activation_discount_code_type = 'D'
              user.activation_discount_code_id = r["discount_code_id"]
              user.customers_abo_type = r["listing_products_allowed"]
              user.customers_next_abo_type = r["next_abo_type"]
              user.group_id = r["group_id"]
              user.tvod_free = user.tvod_free + r["tvod_free"]
              user.customers_abo = 1
              if user.save(:validate => false)
                if user.set_privilegies?
                  user.abo_history(6, user.abo_type_id, r["discount_code_id"])
                  DiscountUse.create(:discount_code_id => r["discount_code_id"], :customer_id => user.to_param, :discount_use_date => Time.now)
                  sign_in(:customer, authentication.customer)
                  redirect_to root_localize_path
                end
              else
                flash[:error] = "Error while creating a user account. Please try again."
                redirect_to root_url
              end
            end
          end
        end

      else

        product = Product.where(:products_id  => moovie_id).first

        if product
          sign_in(:customer, authentication.customer)
          redirect_to product_path(:id => product.to_param)
        else
          sign_in(:customer, authentication.customer)
          redirect_to root_localize_path
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
			            user.tvod_free = user.tvod_free + r["tvod_free"]
                  user.customers_abo = 1
			            if user.save(:validate => false)
                    if user.set_privilegies?
			                activation = Activation.find_by_activation_code(code)
                      user.abo_history(8, user.abo_type_id, activation.to_param)
			                activation.update_attributes(:customers_id => user.to_param, :created_at => Time.now.localtime)
			                sign_in(:customer, auth.customer)
                      redirect_to root_localize_path
                    end
			            else
			              flash[:error] = "Error while creating a user account. Please try again."
			              redirect_to root_url
			            end
			          end
			        end

			        if dresold.present?
                discount = Discount.find_by_discount_code(code)
                if !auth.customer.discount_reuse?(discount.month_before_reuse) && discount.bypass_discountuse == 0
                  if params["ACTION_TYPE"].present? && params["ACTION_TYPE"] == "FREETRIAL"
                    redirect_to freetrial_action_path(:code => code, :freetrial_action => params["freetrial_action"], :films => params["films"], :price => params["price"], :FT_CODE_RESTRICTION => "FTC_ERROR")
                  elsif params["ACTION_TYPE"].present? && params["ACTION_TYPE"] == "NORMAL"
                    redirect_to "#{params["ORG_URL"]};DS_CODE_RESTRICTION_ERROR=DISCOUNT_CODE_LIMIT_AUTH_ERROR"
                  end
                else
  			          dresold.each do |r|
  			            user.customers_registration_step = r["goto_step"]
  			            user.activation_discount_code_type = 'D'
  			            user.activation_discount_code_id = r["discount_code_id"]
  			            user.customers_abo_type = r["listing_products_allowed"]
  			            user.customers_next_abo_type = r["next_abo_type"]
  			            user.group_id = r["group_id"]
  			            user.tvod_free = user.tvod_free + r["tvod_free"]
                    user.customers_abo = 1
  			            if user.save(:validate => false)
                      if user.set_privilegies?
                        user.abo_history(6, user.abo_type_id, r["discount_code_id"])
    			              DiscountUse.create(:discount_code_id => r["discount_code_id"], :customer_id => user.to_param, :discount_use_date => Time.now)
    			              sign_in(:customer, auth.customer)
                        redirect_to root_localize_path
                      end
  			            else
  			              flash[:error] = "Error while creating a user account. Please try again."
  			              redirect_to root_url
  			            end
  			          end
                end
			        end

			      else


              product = Product.where(:products_id  => moovie_id).first

              if product
                sign_in(:customer, auth.customer)
                redirect_to product_path(:id => product.to_param)
              else
                sign_in(:customer, auth.customer)
                redirect_to root_localize_path
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
                if customer.set_privilegies?
                  activation = Activation.find_by_activation_code(code)
                  customer.abo_history(8, customer.abo_type_id, activation.to_param)
                  activation.update_attributes(:customers_id => customer.to_param, :created_at => Time.now.localtime)
                  sign_in(:customer, customer)
                  redirect_to root_localize_path
                end
              else
                flash[:error] = "Error while creating a user account. Please try again."
                redirect_to root_url
              end
            end
          end

          if dres.present?
            discount = Discount.find_by_discount_code(code)
            if !customer.discount_reuse?(discount.month_before_reuse) && discount.bypass_discountuse == 0
              redirect_to freetrial_action_path(:code => code, :freetrial_action => params["freetrial_action"], :films => params["films"], :price => params["price"], :FT_CODE_RESTRICTION => "FTC_ERROR")
            elsif params["ACTION_TYPE"].present? && params["ACTION_TYPE"] == "NORMAL"
              redirect_to "#{params["ORG_URL"]};DS_CODE_RESTRICTION_ERROR=DISCOUNT_CODE_LIMIT_AUTH_ERROR"
            else
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
                  if customer.set_privilegies?
                    customer.abo_history(6, customer.abo_type_id, r["discount_code_id"])
                    DiscountUse.create(:discount_code_id => r["discount_code_id"], :customer_id => customer.to_param, :discount_use_date => Time.now)
                    sign_in(:customer, customer)
                    redirect_to root_localize_path
                  end
                else
                  flash[:error] = "Error while creating a user account. Please try again."
                  redirect_to root_url
                end
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
            if customer.set_privilegies?
              if product
                sign_in(:customer, customer)
                redirect_to product_path(:id => product.to_param)
              else
                sign_in(:customer, customer)
                redirect_to root_localize_path
              end
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
