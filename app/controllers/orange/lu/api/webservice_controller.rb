class Orange::Lu::Api::WebserviceController < ApplicationController
  require 'json'

  def is_eligable
    if request.xhr? && URI(request.referer).path == "/orange/lu/auth/#{I18n.locale}/sms/authorization" && params[:sms_number].present?
      customers_id = customer_signed_in? ? current_customer : 0
      sms_code = SmsCode.new
      sms_code.phone_number = params[:sms_number]
      if sms_code.save!
        render json: sms_code
      end
      #wcf_service_response = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangeIseligable?customers_id=#{customers_id}&mobileNumber=#{params[:sms_number]}&SMSCodeMessage=%22dsgfdag%22&products_id=1758468")
      #if wcf_service_response.body = 0 && SmsCode.create(sms_number: params[:sms_number])
      #  render json: { status: 0, message: "Success message that SMS CODE IS SENT" }
      #elsif wcf_service_response.body = 1
      #  render json: { status: 1, message: "Error" }
      #end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def orange_purchase
    if request.xhr? && URI(request.referer).path == "/orange/lu/auth/#{I18n.locale}/sms/authorization" && params[:sms_code].present?
      customers_id = customer_signed_in? ? current_customer : 0
      wcf_service_response = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangePurchase?customers_id=#{customers_id}&mobileNumber=#{params[:sms_code]}&price=4.99&products_id=1")
      if wcf_service_response.body = 0
        render json: { status: 0, message: "Success message that SMS CODE IS VALID" }
      elsif wcf_service_response.body = 1
        render json: { status: 1, message: "Error" }
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end