class Orange::Lu::Api::WebserviceController < ApplicationController
  require 'json'

  def orange_is_eligable
    if request.xhr?
      resource = Customer.find_for_database_authentication(customers_telephone: params[:sms_number])
      product_id_from_params = params[:products_id].blank? ? 0 : params[:products_id]
      if resource.present?
        orange_sms_activation_code = OrangeSmsActivationCode.new
        orange_sms_activation_code.customers_id = resource.customers_id
        orange_sms_activation_code.phone_number = params[:sms_number]
        orange_sms_activation_code.sms_authentification_code = SecureRandom.hex(2)
        if orange_sms_activation_code.save
          orange_is_eligable_wcf_service = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangeIsEligable?customers_id=#{resource.customers_id}&mobileNumber=#{params[:sms_number]}&SMSCodeMessage=#{puts t("orange.sms_code.message")}#{orange_sms_activation_code.sms_authentification_code}&products_id=#{product_id_from_params}")
          render json: {status: orange_is_eligable_wcf_service, sms_code: "#{t("orange.sms_code.message")} #{orange_sms_activation_code.sms_authentification_code}", phone_number: orange_sms_activation_code.phone_number}
        end
      else
        render json: { status: 0 }
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def orange_register
    if request.xhr?
      product_id_from_params = params[:products_id].blank? ? 0 : params[:products_id]
      customer = Customer.new
      customer.email = "#{SecureRandom.hex(2)}@plush.temp"
      customer.customers_telephone = params[:sms_number]
      if customer.save(validate: false)
        activation_code = OrangeSmsActivationCode.new
        activation_code.customers_id = customer.customers_id
        activation_code.phone_number = params[:sms_number]
        activation_code.sms_authentification_code = SecureRandom.hex(2)
        if activation_code.save(validate: false)
          orange_is_eligable_wcf_service = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangeIsEligable?customers_id=#{customer.customers_id}&mobileNumber=#{params[:sms_number]}&SMSCodeMessage=#{puts t("orange.sms_code.message")}#{activation_code.sms_authentification_code}&products_id=#{product_id_from_params}")
          render json: {status: orange_is_eligable_wcf_service, sms_code: "#{t("orange.sms_code.message")} #{activation_code.sms_authentification_code}", phone_number: activation_code.phone_number}
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def orange_purchase
    if request.xhr?
      resource = Customer.find_for_database_authentication(customers_telephone: params[:plush_phone_number])
      product_id_from_params = params[:products_id].blank? ? 0 : params[:products_id]
      if resource.present?
        discount = Discount.by_name(params[:code]).available.first
        product = Product.find_by_products_id(params[:products_id])
        if discount
          resource.customers_registration_step = 100
          resource.activation_discount_code_type = 'D'
          resource.customers_abo = 1
          resource.customers_abo_type = discount.listing_products_allowed
          resource.customers_next_abo_type = discount.next_abo_type
          resource.group_id = discount.group_id
          resource.tvod_free = discount.tvod_free
        elsif product
          streaming = StreamingProduct.find_by_imdb_id(product.imdb_id)
          resource.step = 100
          resource.customers_abo = 1
          resource.customers_abo_type = 6
          resource.customers_next_abo_type = 6
          resource.customers_abo_validityto = Date.today + 1.month
          resource.preselected_registration_moovie_id = product.to_param
          resource.tvod_free = streaming.tvod_credits
        else
          resource.step = 90
        end
        if resource.save(validate: false)
          sms_authentification_code = OrangeSmsActivationCode.find_by_sms_authentification_code(params[:sms_code])
          if sms_authentification_code.present?
            orange_purchase_wcf_service = HTTParty.get("https://www.plush.be:2355/wcfservice/http/OrangePurchase?customers_id=#{resource.customers_id}&mobileNumber=#{params[:plush_phone_number]}&price=4&products_id=#{product_id_from_params}&message=testCODE2&payment_id=10000")
            render json: {status: orange_purchase_wcf_service}
          end
        end
      else
        render json: {status: "mobile_number_format_error"}
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def check_sms_activation_code
    if request.xhr?
      sms_code = OrangeSmsActivationCode.find_by_sms_authentification_code(params["sms-code"])
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
    if request.xhr?
      customer = Customer.find_for_database_authentication(customers_telephone: params[:plush_phone_number])
      if customer.present? && sign_in(customer, bypass: true)
        if params[:products_id] == "1" || params[:products_id] == "5" || params[:products_id] == "7" || params[:products_id] == "8" || params[:products_id] == "9"
          render json: {status: 0, current_customer_id: customer.customers_id, redirect_path: step_path(:id => 'step4') }
        else
          product = Product.find_by_products_id(params[:products_id])
          if product.present?
            render json: {status: 0, current_customer_id: customer.customers_id, redirect_path: product_path(:id => product.to_param) }
          else
            render json: {status: 0, current_customer_id: customer.customers_id, redirect_path: info_path(:page_name => "alacarte", :subscription_action => "subscription_change") }
          end
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
