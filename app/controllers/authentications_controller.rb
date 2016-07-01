class AuthenticationsController < ApplicationController

	def create
	  auth = request.env["omniauth.auth"]
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
            if cookies[:code].present?
              discount = Discount.find_by_discount_code(cookies[:code])
		  	  activation = Activation.find_by_activation_code(cookies[:code])
	  	  	  if discount.present?
	  	  	    auth.customer.tvod_free = auth.customer.tvod_free + discount.tvod_free if auth.customer.abo_type_id == 6	
	  	  	    DiscountUse.create(:discount_code_id => discount.id, :customer_id => auth.customer.to_param, :discount_use_date => Time.now)
	  	  	  elsif activation.present?
	  	  	    auth.customer.tvod_free = auth.customer.tvod_free + activation.tvod_free if auth.customer.abo_type_id == 6
	  	  	    activation.update_attributes(:customers_id => auth.customer.to_param, :created_at => Time.now.localtime)
	  	  	  end
		  	  auth.customer.facebook_activation = 1
		  	  auth.customer.step = 33
		  	  if auth.customer.save(:validate => false)
		  	  	sign_in_and_redirect(:customer, auth.customer)
		  	  	flash[:notice] = t('session.promotion.sucess')
		  	  end
            end
	        sign_in_and_redirect(:customer, auth.customer)
	      end
	  	else

	  	  customer = Customer.new
	      customer.apply_omniauth(auth)

	  	  if cookies[:code].present?
	  	  	discount = Discount.find_by_discount_code(cookies[:code])
	  	  	activation = Activation.find_by_activation_code(cookies[:code])

	  	  	if discount.present?
	  	  	  customer.tvod_free = customer.tvod_free + discount.tvod_free if customer.abo_type_id == 6	
	  	  	  DiscountUse.create(:discount_code_id => discount.id, :customer_id => customer.to_param, :discount_use_date => Time.now)
	  	  	elsif activation.present?
	  	  	  customer.tvod_free = customer.tvod_free + activation.tvod_free if customer.abo_type_id == 6
	  	  	  activation.update_attributes(:customers_id => customer.to_param, :created_at => Time.now.localtime)
	  	  	end

	  	  	customer.code = cookies[:code]
          else
          	discount = Discount.find_by_discount_code("2FILMSFREE")
          	customer.code = "2FILMSFREE"
	  	  end
	  	  customer.facebook_activation = 1
	  	  customer.step = 33
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
