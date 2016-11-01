class Api::V1::VirementController < ApplicationController

  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_customer!
  protect_from_forgery except: [:accept_virement_payment]

  def accept_virement_payment
    if params[:first_name].present? && params[:last_name].present?
      customer = current_customer
      customer.customers_firstname = params[:first_name]
      customer.customers_lastname = params[:last_name]
      customer.customers_abo_payment_method = 3
      customer.customers_registration_step = 100
      customers_abo = 1
      if customer.have_freetrial_codes?
        customer.customers_abo_validityto = Time.now + 1.month
      else
        customer.customers_abo_validityto = Time.now
        customer.customers_locked__for_reconduction = 1
        customer.credits_already_recieved = 1
      end
      if customer.save(validate: false)
        redirect_to step_path(:id => 'step4')
	    end
    end
  end

end
