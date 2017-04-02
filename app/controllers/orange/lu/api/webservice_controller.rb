class Orange::Lu::Api::WebserviceController < ApplicationController
  require 'json'

  def is_eligable
    if request.xhr? #&& URI(request.referer).path == "/orange/lu/auth/#{I18n.locale}/sms/authorization" && params[:sms_number].present? && params[:products_id].present?
      customers_id = customer_signed_in? ? current_customer : 0
      sms_code = SmsCode.new
      sms_code.phone_number = params[:sms_number]
      if sms_code.save!
        if sms_code.update_attribute(:temporary_email, "#{sms_code.code}@plush.temp")
          customer = Customer.new
          customer.email = sms_code.temporary_email.downcase
          customer.customers_registration_step = 100
          if customer.save(validate: false)
            wsr = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangeIseligable?customers_id=#{customers_id}&mobileNumber=#{params[:sms_number]}&SMSCodeMessage=#{puts t("orange.sms_code.message")}#{sms_code.code}&products_id=#{params[:products_id]}")
            if wsr.body = 0
              render json: {status: 0, message: "Success message that SMS CODE IS SENT", sms_code: sms_code.code, temporary_email: sms_code.temporary_email.downcase}
            elsif wsr.body = 1
              render json: {status: 1, message: "Error"}
            end
          end
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def orange_purchase
    if request.xhr? #&& URI(request.referer).path == "/orange/lu/auth/#{I18n.locale}/sms/authorization" && params[:sms_code].present? && params[:products_id].present?
      customers_id = customer_signed_in? ? current_customer : 0
      product = Product.find(params[:products_id])
      wcf_service_response = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangePurchase?customers_id=#{customers_id}&mobileNumber=#{params[:sms_code]}&price=#{product.products_price}&products_id=#{params[:products_id]}")
      if wcf_service_response.body = 0
        #render json: { status: 0, message: "Success message that SMS CODE IS VALID" }
        customer = Customer.find_by_email(params["temporary_email"])
        if customer.present? && sign_in(customer, bypass: true)
          render json: {status: 0, root_localize_path: root_localize_path}
        end
      elsif wcf_service_response.body = 1
        render json: { status: 1, message: "Error" }
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def check_sms_activation_code
    if request.xhr? #&& URI(request.referer).path == "/orange/lu/auth/#{I18n.locale}/sms/authorization" && params["sms-code"].present?
      sms_code = SmsCode.find_by_code(params["sms-code"])
      if sms_code.present?
        render json: TRUE
      else
        render json: FALSE
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def automatic_login
    if request.xhr? #&& params["temporary_email"].present?
      customer = Customer.find_by_email(params["temporary_email"])
      if customer.present? && sign_in(customer, bypass: true)
        render json: {status: 0, root_localize_path: root_localize_path}
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end