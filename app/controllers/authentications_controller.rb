class AuthenticationsController < ApplicationController

	def create
	  auth = request.env["omniauth.auth"]

	  # Try to find authentication first
	  authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])

	  if authentication
	    # Authentication found, sign the user in.
	    flash[:notice] = "Signed in successfully."
	    sign_in_and_redirect(:customer, authentication.customer)
	  else
	    # Authentication not found, thus a new user.
	    customer = Customer.new
	    customer.apply_omniauth(auth)
	    customer.confirmed_at = Time.now
	    #customer.facebook_tag = "from_facebook"
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
