class Orange::Lu::Api::WebserviceController < ApplicationController
  #skip_before_filter :verify_authenticity_token
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
          orange_is_eligable_wcf_service = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangeIsEligable?customersId=#{resource.customers_id}&mobileNumber=#{params[:sms_number]}&SMSCodeMessage=#{puts t("orange.sms_code.message")}#{orange_sms_activation_code.sms_authentification_code}&products_id=#{product_id_from_params}")
          render json: {status: orange_is_eligable_wcf_service, sms_code: "#{t("orange.sms_code.message")} #{orange_sms_activation_code.sms_authentification_code}", phone_number: orange_sms_activation_code.phone_number}
        end
      else
        if product_id_from_params == 0
          render json: {status: 0, sms_number: params[:sms_number]}
        else
          render json: {status: 1, sms_number: params[:sms_number]}
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def orange_is_eligable_ppv
    if request.xhr?
      customer = Customer.find(params[:customers_id])
      product_id_from_params = params[:products_id].blank? ? 0 : params[:products_id]
      if customer.present?
        customer.customers_telephone = params[:sms_number]
        if customer.save(validate: false)
          orange_sms_activation_code = OrangeSmsActivationCode.new
          orange_sms_activation_code.customers_id = customer.customers_id
          orange_sms_activation_code.phone_number = params[:sms_number]
          orange_sms_activation_code.sms_authentification_code = SecureRandom.hex(2)
          if orange_sms_activation_code.save
            orange_is_eligable_wcf_service = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangeIsEligable?customersId=#{customer.customers_id}&mobileNumber=#{params[:sms_number]}&SMSCodeMessage=#{puts t("orange.sms_code.message")}#{orange_sms_activation_code.sms_authentification_code}&products_id=#{product_id_from_params}")
            render json: {status: orange_is_eligable_wcf_service, sms_code: "#{t("orange.sms_code.message")} #{orange_sms_activation_code.sms_authentification_code}", phone_number: orange_sms_activation_code.phone_number}
          end
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def orange_is_eligable_step3
    if request.xhr?
      customer = Customer.find(params[:customers_id])
      product_id_from_params = params[:products_id].blank? ? 0 : params[:products_id]
      if customer.present?
        customer.customers_telephone = params[:sms_number]
        if customer.save(validate: false)
          orange_sms_activation_code = OrangeSmsActivationCode.new
          orange_sms_activation_code.customers_id = customer.customers_id
          orange_sms_activation_code.phone_number = params[:sms_number]
          orange_sms_activation_code.sms_authentification_code = SecureRandom.hex(2)
          if orange_sms_activation_code.save
            orange_is_eligable_wcf_service = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangeIsEligable?customersId=#{customer.customers_id}&mobileNumber=#{params[:sms_number]}&SMSCodeMessage=#{puts t("orange.sms_code.message")}#{orange_sms_activation_code.sms_authentification_code}&products_id=#{product_id_from_params}")
            render json: {status: orange_is_eligable_wcf_service, sms_code: "#{t("orange.sms_code.message")} #{orange_sms_activation_code.sms_authentification_code}", phone_number: orange_sms_activation_code.phone_number}
          end
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def orange_login
    if request.xhr?
      #product_id_from_params = params[:products_id].blank? ? 0 : params[:products_id]
      sms_code = OrangeSmsActivationCode.find_by_sms_authentification_code(params[:sms_code])
      if sms_code.present?
        customer = Customer.find(sms_code.customers_id)
        if customer.present?
          render json: {status: "True"}
        end
      else
        render json: {status: 0}
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def orange_register
    if request.xhr?
      product_id_from_params = params[:products_id].blank? ? 0 : params[:products_id]
      customer = Customer.new
      customer.email = "#{params[:sms_number]}@orange.lu"
      customer.customers_telephone = params[:sms_number]
      #customer.customers_registration_step = 100
      #customer.customers_abo = 1
      #customer.customers_abo_type = 6
      #customer.customers_next_abo_type = 6
      if customer.save(validate: false)
        activation_code = OrangeSmsActivationCode.new
        activation_code.customers_id = customer.customers_id
        activation_code.phone_number = params[:sms_number]
        activation_code.sms_authentification_code = SecureRandom.hex(2)
        if activation_code.save(validate: false)
          orange_is_eligable_wcf_service = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangeIsEligable?customersId=#{customer.customers_id}&mobileNumber=#{params[:sms_number]}&SMSCodeMessage=#{puts t("orange.sms_code.message")}#{activation_code.sms_authentification_code}&products_id=#{product_id_from_params}")
          render json: {status: orange_is_eligable_wcf_service, sms_code: "#{t("orange.sms_code.message")} #{activation_code.sms_authentification_code}", phone_number: activation_code.phone_number}
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def orange_purchase
    if request.xhr?
      product_id_from_params = params[:products_id].blank? ? 0 : params[:products_id]
      sms_code = OrangeSmsActivationCode.find_by_sms_authentification_code(params[:sms_code])
      discount = Discount.by_name(params[:code]).available.first
      product = Product.find_by_products_id(params[:products_id])
      streaming = StreamingProduct.find_by_imdb_id(product.imdb_id)
      if sms_code.present?
        customer = Customer.find(sms_code.customers_id)
        if customer.present?
          orange_purchase_wcf_service = HTTParty.get("https://www.plush.be:2355/wcfservice/http/OrangePurchase?customersId=#{customer.customers_id}&mobileNumber=#{params[:plush_phone_number]}&price=0&products_id=#{product_id_from_params}&message=subscription&payment_id=0")
          if orange_purchase_wcf_service.parsed_response == "TRUE"
            if discount.present?
              customer.customers_registration_step = 100
              customer.activation_discount_code_type = 'D'
              customer.customers_abo = 1
              customer.customers_abo_type = discount.listing_products_allowed
              customer.customers_next_abo_type = discount.next_abo_type
              customer.group_id = discount.group_id
              customer.tvod_free = discount.tvod_free
              customer.customers_abo_validityto = Date.today + 1.month
              customer.customers_abo_payment_method = 5
              customer.activation_discount_code_id = discount.discount_code_id
              if customer.save(validate: false)
                if customer.abo_history(7, customer.customers_abo_type, product_id_from_params) && customer.abo_history(6, customer.customers_abo_type, discount.to_param)
                  #sign_in(customer)
                  render json: {status: "TRUE"}
                end
              end
            elsif streaming.present?
              customer.customers_registration_step = 100
              customer.activation_discount_code_type = 'D'
              customer.customers_abo = 1
              customer.customers_abo_type = 6
              customer.customers_next_abo_type = 6
              customer.tvod_free = 0
              customer.customers_abo_payment_method = 5
              customer.activation_discount_code_id = 0
              if customer.save(validate: false)
                if customer.abo_history(6, customer.customers_abo_type, streaming.to_param)
                  #sign_in(customer)
                  render json: {status: "TRUE"}
                end
              end
            end
          else
            #sign_in(customer)
            render json: {status: orange_purchase_wcf_service.parsed_response}
          end
        end
      else
        render json: {status: "mobile_number_format_error"}
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def orange_purchase_ppv
    if request.xhr?
      product_id_from_params = params[:products_id].blank? ? 0 : params[:products_id]
      sms_code = OrangeSmsActivationCode.find_by_sms_authentification_code(params[:sms_code])
      product = Product.find_by_products_id(params[:products_id])
      streaming = StreamingProduct.find_by_imdb_id(product.imdb_id)
      if sms_code.present?
        customer = Customer.find(sms_code.customers_id)
        if customer.present?
          customer.step = 100
          customer.customers_abo = 1
          if customer.save(validate: false)
            orange_purchase_wcf_service = HTTParty.get("https://www.plush.be:2355/wcfservice/http/OrangePurchase?customersId=#{customer.customers_id}&mobileNumber=#{params[:plush_phone_number]}&price=0&products_id=#{product_id_from_params}&message=ppv2&payment_id=0")
            if orange_purchase_wcf_service.parsed_response == "TRUE"
              if streaming.present?
                sign_in(customer)
                render json: {status: "True"}
              end
            else
              sign_in(customer)
              render json: {status: orange_purchase_wcf_service}
            end
          end
        end
      else
        render json: {status: "mobile_number_format_error"}
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def orange_purchase_step3
    if request.xhr?
      sms_code = OrangeSmsActivationCode.find_by_sms_authentification_code(params[:sms_code])
      if sms_code.present?
        customer =  Customer.find(params[:current_customer])
        if customer.present?
          orange_purchase_wcf_service = HTTParty.get("https://www.plush.be:2355/wcfservice/http/OrangePurchase?customersId=#{customer.customers_id}&mobileNumber=#{params[:plush_phone_number]}&price=0&products_id=#{customer.customers_abo_type}&message=ppv2&payment_id=0")
          if orange_purchase_wcf_service.parsed_response == "TRUE"
              customer.customers_registration_step = 100
              customer.customers_abo = 1
              customer.customers_abo_validityto = Date.today + 1.month
              customer.customers_abo_payment_method = 5
              if customer.save(validate: false)
                if customer.abo_history(7, customer.customers_abo_type, customer.customers_abo_payment_method) # !!!
                  sign_in(customer)
                  render json: {status: "True"}
                end
              end
          else
            sign_in(customer)
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

  # ORANGE LOGIN STRANA
  def automatic_login
    if request.xhr?
      customer = Customer.find_for_database_authentication(customers_telephone: params[:plush_phone_number])
      if customer.present?
        if params[:products_id] == "1" || params[:products_id] == "5" || params[:products_id] == "7" || params[:products_id] == "8" || params[:products_id] == "9"
          sign_in(customer)
          render json: {status: 0, current_customer_id: customer.customers_id, redirect_path: info_path(:page_name => t('routes.infos.params.alacarte'), :subscription_action => "subscription_change")}
        else
          product = Product.find_by_products_id(params[:products_id])
          if product.present?
            sign_in(customer)
            render json: {status: 0, current_customer_id: customer.customers_id, redirect_path: product_path(:id => product.to_param)}
          else
            sign_in(customer)
            render json: {status: 0, current_customer_id: customer.customers_id, redirect_path: root_localize_path}
          end
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  # ORANGE REGISTER STRANA
  def automatic_register
    if request.xhr?
      customer = Customer.find_for_database_authentication(customers_telephone: params[:plush_phone_number])
      if customer.present?
        if params[:products_id] == "1" || params[:products_id] == "5" || params[:products_id] == "7" || params[:products_id] == "8" || params[:products_id] == "9"
          sign_in(customer)
          render json: {status: 0, current_customer_id: customer.customers_id, redirect_path: step_path(:id => 'step4')}
        else
          product = Product.find_by_products_id(params[:products_id])
          if product.present?
            sign_in(customer)
            render json: {status: 0, current_customer_id: customer.customers_id, redirect_path: streaming_product_path(:id => product.imdb_id, :season_id => product.season_id, :episode_id => product.episode_id)}
          else
            sign_in(customer)
            render json: {status: 0, current_customer_id: customer.customers_id, redirect_path: root_localize_path}
          end
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
