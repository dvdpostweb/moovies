class Api::V1::PaypalController < ApplicationController

  API_USERNAME = ENV["API_USERNAME"]
  API_PASSWORD = ENV["API_PASSWORD"]
  API_SIGNATURE = ENV["API_SIGNATURE"]
  BILLING_AGREEMENT_DESCRIPTION = ENV["BILLING_AGREEMENT_DESCRIPTION"]
  RETURN_URL = "#{ENV["APP_DOMAIN_URL"]}/api/v1/express_checkout_return"
  CANCEL_RETURL_URL = "#{ENV["APP_DOMAIN_URL"]}/#{I18n.locale}/steps/step3"

  def express_checkout
    request = Paypal::Express::Request.new(
      :username   => API_USERNAME,
      :password   => API_PASSWORD,
      :signature  => API_SIGNATURE
    )
    payment_request = Paypal::Payment::Request.new(
      :billing_type  => :MerchantInitiatedBilling,
      # Or ":billing_type => :MerchantInitiatedBillingSingleAgreement"
      # Read official document for details
      :billing_agreement_description => BILLING_AGREEMENT_DESCRIPTION
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

end
