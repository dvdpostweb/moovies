class SocialActivationController < ApplicationController
  before_filter :authenticate_customer!

  def activate
  	if params[:customer_email].present? && params[:activation_dicsount_code_id].present?
  	  customer = Customer.find_by_email(params[:customer_email])
  	  customer.activation_discount_code_id = params[:activation_dicsount_code_id]
  	  customer.customers_registration_step = 31
  	  customer.facebook_activation = 1
  	  if customer.save!
        render :json => { :status => 1 }
      else
        render :json => { :status => 0 }
      end
    end		
  end
end
