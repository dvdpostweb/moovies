class Api::V1::PaypalController < ApplicationController

  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_customer!
  protect_from_forgery except: [:express_checkout_return, :express_checkout_notifications]

  API_USERNAME = ENV["API_USERNAME"]
  API_PASSWORD = ENV["API_PASSWORD"]
  API_SIGNATURE = ENV["API_SIGNATURE"]
  BILLING_AGREEMENT_DESCRIPTION = ENV["BILLING_AGREEMENT_DESCRIPTION"]
  RETURN_URL = "#{ENV["APP_DOMAIN_URL"]}/api/v1/express_checkout_return"
  CANCEL_RETURL_URL = "#{ENV["APP_DOMAIN_URL"]}/#{I18n.locale}/steps/step3"
  NOTIFY_URL = "#{ENV["APP_DOMAIN_URL"]}/api/v1/express_checkout_notifications"

  def express_checkout
    request = Paypal::Express::Request.new(
      :username   => API_USERNAME,
      :password   => API_PASSWORD,
      :signature  => API_SIGNATURE
    )
    payment_request = Paypal::Payment::Request.new(
      :billing_type  => :MerchantInitiatedBilling,
      :billing_agreement_description => BILLING_AGREEMENT_DESCRIPTION
    )
    response = request.setup(
      payment_request,
      RETURN_URL,
      CANCEL_RETURL_URL
    )
    redirect_to response.redirect_uri
  end

  def express_checkout_payment_method_change_to_paypal
    request = Paypal::Express::Request.new(
      :username   => API_USERNAME,
      :password   => API_PASSWORD,
      :signature  => API_SIGNATURE
    )
    payment_request = Paypal::Payment::Request.new(
      :billing_type  => :MerchantInitiatedBilling,
      :billing_agreement_description => BILLING_AGREEMENT_DESCRIPTION,
      payment_method_change_to_paypal: "payment_method_change_to_paypal"
    )
    response = request.setup(
      payment_request,
      RETURN_URL,
      CANCEL_RETURL_URL
    )
    redirect_to response.redirect_uri
  end

  def express_checkout_return
    render json: params
  end

  def express_checkout_return_1
    if params[:token].present?
      request = Paypal::Express::Request.new(
        :username   => API_USERNAME,
        :password   => API_PASSWORD,
        :signature  => API_SIGNATURE
      )
      token = params[:token]
      response = request.agree! token
      customer = current_customer
      customer.customers_abo_payment_method = 4
      customer.customers_registration_step = 100
      customers_abo = 1
      customer.paypal_agreement_id = response.billing_agreement.identifier
      if customer.have_freetrial_codes?
        customer.customers_abo_validityto = Time.now + 1.month
      else
        customer.customers_abo_validityto = Time.now
        customer.customers_locked__for_reconduction = 1
        customer.credits_already_recieved = 1
      end
      if customer.save(validate: false)
        discount = Discount.find_by_discount_code(customer.activation_discount_code_id)
        if customer.have_freetrial_codes?
          if customer.abo_history(12, customer.abo_type_id, discount.to_param)
            redirect_to step_path(:id => 'step4')
          end
        else
          if customer.abo_history(6, customer.abo_type_id, discount.to_param)
            redirect_to step_path(:id => 'step4')
          end
        end
	    end
    end
  end

end
