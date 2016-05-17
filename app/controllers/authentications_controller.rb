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
	  	  new_auth.email = auth['extra']['raw_info']['email']
	  	  if new_auth.save
            auth = Authentication.find_by_provider_and_uid_and_email(auth['provider'], auth['uid'], auth['extra']['raw_info']['email'])
	        sign_in_and_redirect(:customer, auth.customer)
	      end
	  	else
	  	  customer = Customer.new
	      customer.apply_omniauth(auth)
	      customer.skip_confirmation!
	      if customer.save(:validate => false)
	        flash[:notice] = "Account created and signed in successfully."
	        sign_in_and_redirect(:customer, customer)
	      else
	        flash[:error] = "Error while creating a user account. Please try again."
	        redirect_to root_url
	      end
	    end
	  end
	end

end
