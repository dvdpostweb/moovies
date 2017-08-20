class Orange::Lu::Api::WebserviceController < ApplicationController #API::V1::BaseController #ApplicationController
  skip_before_filter :authenticate_customer!
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
          orange_is_eligable_wcf_service = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangeIsEligable?customersId=#{resource.customers_id}&mobileNumber=#{params[:sms_number]}&SMSCodeMessage=#{puts t("orange.sms_code.message")}#{orange_sms_activation_code.sms_authentification_code}&products_id=#{product_id_from_params}&locale=#{I18n.locale}")
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
            orange_is_eligable_wcf_service = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangeIsEligable?customersId=#{customer.customers_id}&mobileNumber=#{params[:sms_number]}&SMSCodeMessage=#{puts t("orange.sms_code.message")}#{orange_sms_activation_code.sms_authentification_code}&products_id=#{product_id_from_params}&locale=#{I18n.locale}")
            sign_in(customer)
            render json: {status: orange_is_eligable_wcf_service, sms_code: "#{t("orange.sms_code.message_payment")} #{orange_sms_activation_code.sms_authentification_code}", phone_number: orange_sms_activation_code.phone_number}
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
            orange_is_eligable_wcf_service = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangeIsEligable?customersId=#{customer.customers_id}&mobileNumber=#{params[:sms_number]}&SMSCodeMessage=#{puts t("orange.sms_code.message")}#{orange_sms_activation_code.sms_authentification_code}&products_id=#{product_id_from_params}&locale=#{I18n.locale}")
            sign_in(customer)
            render json: {status: orange_is_eligable_wcf_service, sms_code: "#{t("orange.sms_code.message_payment")} #{orange_sms_activation_code.sms_authentification_code}", phone_number: orange_sms_activation_code.phone_number}
          end
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  #def orange_login
  #  if request.xhr?
      #product_id_from_params = params[:products_id].blank? ? 0 : params[:products_id]
  #    sms_code = OrangeSmsActivationCode.find_by_sms_authentification_code(params[:sms_code])
  #    if sms_code.present?
  #      customer = Customer.find(sms_code.customers_id)
  #      if customer.present?
  #        render json: {status: "True"}
  #      end
  #    else
  #      render json: {status: 0}
  #    end
  #  else
  #    raise ActionController::RoutingError.new('Not Found')
  #  end
  #end

  def orange_login
    if request.xhr?
      product_id_from_params = params[:products_id].blank? ? 0 : params[:products_id]
      sms_code = OrangeSmsActivationCode.find_by_sms_authentification_code(params[:sms_code])

      discount = Discount.by_name(params[:code]).available.first

      if sms_code.present?
        customer = Customer.find(sms_code.customers_id)

        if customer.present?
          product = Product.find_by_products_id(product_id_from_params)
          streaming = StreamingProduct.find_by_imdb_id(product.imdb_id) if product

          if customer.tvod_only? && product_id_from_params.to_i > 10 && customer.tvod_free < streaming.tvod_credits
            orange_purchase_wcf_service = HTTParty.get("https://www.plush.be:2355/wcfservice/http/OrangePurchase?customersId=#{customer.customers_id}&mobileNumber=#{params[:plush_phone_number]}&price=0&products_id=#{product_id_from_params}&message=subscription&payment_id=0&locale=#{I18n.locale}")

            if orange_purchase_wcf_service.parsed_response == "TRUE"

              if streaming.present?
                sign_in(customer)
                render json: {status: 1, redirect_path: streaming_product_path(:id => product.imdb_id, :season_id => product.season_id, :episode_id => product.episode_id)}
              end
            else
              sign_in(customer)
              render json: {status: 2, msg: orange_purchase_wcf_service, redirect_path: product_path(:id => product.to_param)}
            end
          elsif customer.tvod_only? && product_id_from_params.to_i > 10 && customer.tvod_free >= streaming.tvod_credits
            sign_in(customer)
            render json: {status: 3, msg: orange_purchase_wcf_service, redirect_path: streaming_product_path(:id => product.imdb_id, :season_id => product.season_id, :episode_id => product.episode_id)}
          elsif params[:products_id] == "1" || params[:products_id] == "5" || params[:products_id] == "7" || params[:products_id] == "8" || params[:products_id] == "9"
            if customer.customers_locked__for_reconduction == 1 || current_customer.tvod_free > 0
              sign_in(customer)
              render json: {status: 4, msg: t('streaming_products.renew_subscription_error_orange_login'), redirect_path: root_localize_path}
            else

              if discount.present?

                orange_purchase_wcf_service = HTTParty.get("https://www.plush.be:2355/wcfservice/http/OrangePurchase? customersId=#{customer.customers_id}&mobileNumber=#{params[:plush_phone_number]}&price=0&products_id=#{product_id_from_params}&message=subscription&payment_id=0&locale=#{I18n.locale}")
                if orange_purchase_wcf_service.parsed_response == "TRUE"
                  customer.customers_registration_step = 100
                  customer.customers_abo = 1
                  customer.customers_abo_type = discount.listing_products_allowed
                  customer.customers_next_abo_type = discount.next_abo_type
                  customer.activation_discount_code_type = 'D'
                  customer.tvod_free = discount.tvod_free
                  customer.customers_abo_payment_method = 5


                  if customer.save(validate: false)
                    if customer.abo_history(7, customer.customers_abo_type, customer.customers_abo_payment_method) # !!!
                      sign_in(customer)
                      render json: {status: 5, redirect_path: root_localize_path}
                    end
                  end
                else

                  customer.customers_registration_step = 33
                  customer.customers_abo = 1
                  customer.customers_abo_type = discount.listing_products_allowed
                  customer.customers_next_abo_type = discount.next_abo_type
                  customer.activation_discount_code_type = 'D'
                  customer.tvod_free = discount.tvod_free
                  customer.customers_abo_payment_method = 5


                  if customer.save(validate: false)
                    if customer.abo_history(7, customer.customers_abo_type, customer.customers_abo_payment_method) # !!!
                      sign_in(customer)
                      render json: {status: 6, msg: orange_purchase_wcf_service, redirect_path: root_localize_path}
                    end
                  end

                end

              end

            end
          else
            render json: {status: "True"}
          end
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
      discount = Discount.by_name(params[:code]).available.first
      product = Product.find_by_products_id(params[:products_id])
      activation_for_orange_promotion = Activation.by_name(params[:orange_luxembourg_promo_code]).available.first
      customer = Customer.new
      customer.email = "#{params[:sms_number]}@orange.lu"
      customer.customers_telephone = params[:sms_number]
      if discount.present?
        customer.customers_registration_step = 33
        customer.customers_abo = 1
        customer.customers_abo_type = discount.listing_products_allowed
        customer.customers_next_abo_type = discount.next_abo_type
        customer.activation_discount_code_type = 'D'
        customer.tvod_free = discount.tvod_free
        customer.customers_abo_payment_method = 5
        if customer.save(validate: false)
          activation_code = OrangeSmsActivationCode.new
          activation_code.customers_id = customer.customers_id
          activation_code.phone_number = params[:sms_number]
          activation_code.sms_authentification_code = SecureRandom.hex(2)
          if activation_code.save(validate: false)
            orange_is_eligable_wcf_service = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangeIsEligable?customersId=#{customer.customers_id}&mobileNumber=#{params[:sms_number]}&SMSCodeMessage=#{puts t("orange.sms_code.message")}#{activation_code.sms_authentification_code}&products_id=#{product_id_from_params}&locale=#{I18n.locale}")
            render json: {status: orange_is_eligable_wcf_service, sms_code: "#{t("orange.sms_code.message_payment")} #{activation_code.sms_authentification_code}", phone_number: activation_code.phone_number}
          end
        end
      elsif product.present?
        customer.customers_registration_step = 100
        customer.customers_abo = 1
        customer.customers_abo_type = 6
        customer.customers_next_abo_type = 6
        customer.activation_discount_code_type = 'A'
        customer.customers_abo_payment_method = 5
        if customer.save(validate: false)
          activation_code = OrangeSmsActivationCode.new
          activation_code.customers_id = customer.customers_id
          activation_code.phone_number = params[:sms_number]
          activation_code.sms_authentification_code = SecureRandom.hex(2)
          if activation_code.save(validate: false)
            orange_is_eligable_wcf_service = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangeIsEligable?customersId=#{customer.customers_id}&mobileNumber=#{params[:sms_number]}&SMSCodeMessage=#{puts t("orange.sms_code.message")}#{activation_code.sms_authentification_code}&products_id=#{product_id_from_params}&locale=#{I18n.locale}")
            render json: {status: orange_is_eligable_wcf_service, sms_code: "#{t("orange.sms_code.message_payment")} #{activation_code.sms_authentification_code}", phone_number: activation_code.phone_number}
          end
        end
      elsif activation_for_orange_promotion.present?
        customer.customers_registration_step = 100
        customer.customers_abo = 1
        customer.activation_discount_code_type = 'A'
        customer.activation_discount_code_id = activation_for_orange_promotion.activation_id
        customer.customers_abo_type = activation_for_orange_promotion.activation_products_id
        customer.customers_next_abo_type = activation_for_orange_promotion.next_abo_type
        customer.group_id = activation_for_orange_promotion.activation_group
        customer.customers_next_discount_code = activation_for_orange_promotion.next_discount
        customer.tvod_free = activation_for_orange_promotion.tvod_free
        customer.customers_abo_payment_method = 5
        customer.customers_abo_validityto = Time.now + 1.month
        if customer.save(validate: false)

          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "__________________________________________________________________________________________________"
          logger.info "__________________________________________________________________________________________________"
          logger.info "                                                                                                  "
          logger.info " ORANGE CUSTOMER CREATED WITH EMAIL: #{customer.email}                                            "
          logger.info " ORANGE CUSTOMER CREATED WITH ACTIVATION CODE: #{params[:orange_luxembourg_promo_code]}           "
          logger.info "__________________________________________________________________________________________________"
          logger.info "__________________________________________________________________________________________________"
          logger.info "                                                                                                  "
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"
          logger.info "##################################################################################################"

          if activation_for_orange_promotion.update_attributes(:customers_id => customer.to_param, :created_at => Time.now.localtime)

            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "__________________________________________________________________________________________________"
            logger.info "__________________________________________________________________________________________________"
            logger.info "                                                                                                  "
            logger.info " ACTIVATION UPDATE ATTRIBUTES WITH CUSTOMER: #{customer.to_param}                                 "
            logger.info " ACTIVATION UPDATE ATTRIBUTES CREATED AT: #{Time.now.localtime}                                   "
            logger.info "__________________________________________________________________________________________________"
            logger.info "__________________________________________________________________________________________________"
            logger.info "                                                                                                  "
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"

            if customer.abo_history(38, customer.abo_type_id, activation_for_orange_promotion.to_param)

              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "__________________________________________________________________________________________________"
              logger.info "__________________________________________________________________________________________________"
              logger.info "                                                                                                  "
              logger.info " ABO HISTORY PARAM1: #{38}                                                                        "
              logger.info " ABO HISTORY PARAM2: #{customer.abo_type_id}                                                      "
              logger.info " ABO HISTORY PARAM3: #{activation_for_orange_promotion.to_param}                                  "
              logger.info "__________________________________________________________________________________________________"
              logger.info "__________________________________________________________________________________________________"
              logger.info "                                                                                                  "
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"
              logger.info "##################################################################################################"

              activation_code = OrangeSmsActivationCode.new
              activation_code.customers_id = customer.customers_id
              activation_code.phone_number = params[:sms_number]
              activation_code.sms_authentification_code = SecureRandom.hex(2)
              if activation_code.save(validate: false)

                orange_is_eligable_wcf_service = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangeIsEligable?customersId=#{customer.customers_id}&mobileNumber=#{params[:sms_number]}&SMSCodeMessage=#{puts t("orange.sms_code.message")}#{activation_code.sms_authentification_code}&products_id=#{activation_for_orange_promotion.to_param}&locale=#{I18n.locale}")
                render json: {status: orange_is_eligable_wcf_service, sms_code: "#{t("orange.sms_code.message_payment")} #{activation_code.sms_authentification_code}", phone_number: activation_code.phone_number}

                #render json: { status: "ok" }

              end

            end
          end
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
      if params[:products_id].present?
        product = Product.find_by_products_id(params[:products_id])
        streaming = StreamingProduct.find_by_imdb_id(product.imdb_id)
      end
      activation_for_orange_promotion = Activation.by_name(params[:orange_luxembourg_promo_code]).first
      if sms_code.present?
        customer = Customer.find(sms_code.customers_id)
        if customer.present?
          if params[:orange_luxembourg_promo_code].present?

            render json: { status: "TRUE" }

            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "__________________________________________________________________________________________________"
            logger.info "__________________________________________________________________________________________________"
            logger.info "                                                                                                  "
            logger.info " Customer use promo code and skip payment                                                         "
            logger.info "__________________________________________________________________________________________________"
            logger.info "__________________________________________________________________________________________________"
            logger.info "                                                                                                  "
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"

          else

            orange_purchase_wcf_service = HTTParty.get("https://www.plush.be:2355/wcfservice/http/OrangePurchase?customersId=#{customer.customers_id}&mobileNumber=#{params[:plush_phone_number]}&price=0&products_id=#{product_id_from_params}&message=subscription&payment_id=0&locale=#{I18n.locale}")
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
        end
      else
        render json: {status: activation_code_error_message(I18n.locale)}
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
            orange_purchase_wcf_service = HTTParty.get("https://www.plush.be:2355/wcfservice/http/OrangePurchase?customersId=#{customer.customers_id}&mobileNumber=#{params[:plush_phone_number]}&price=0&products_id=#{product_id_from_params}&message=ppv2&payment_id=0&locale=#{I18n.locale}")
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
        render json: {status: activation_code_error_message(I18n.locale)}
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
          orange_purchase_wcf_service = HTTParty.get("https://www.plush.be:2355/wcfservice/http/OrangePurchase?customersId=#{customer.customers_id}&mobileNumber=#{params[:plush_phone_number]}&price=0&products_id=#{customer.customers_abo_type}&message=ppv2&payment_id=0&locale=#{I18n.locale}")
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
        render json: {status: activation_code_error_message(I18n.locale)}
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

        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "__________________________________________________________________________________________________"
        logger.info "__________________________________________________________________________________________________"
        logger.info "                                                                                                  "
        logger.info " SMS ACTIVATION CODE IS OK                                                                        "
        logger.info "__________________________________________________________________________________________________"
        logger.info "__________________________________________________________________________________________________"
        logger.info "                                                                                                  "
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"

      else

        render json: FALSE

        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "__________________________________________________________________________________________________"
        logger.info "__________________________________________________________________________________________________"
        logger.info "                                                                                                  "
        logger.info " SMS ACTIVATION CODE NOT OK                                                                       "
        logger.info "__________________________________________________________________________________________________"
        logger.info "__________________________________________________________________________________________________"
        logger.info "                                                                                                  "
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"
        logger.info "##################################################################################################"

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

            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "__________________________________________________________________________________________________"
            logger.info "__________________________________________________________________________________________________"
            logger.info "                                                                                                  "
            logger.info " DEVISE SIGN IN CUSTOMER                                                                          "
            logger.info "__________________________________________________________________________________________________"
            logger.info "__________________________________________________________________________________________________"
            logger.info "                                                                                                  "
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"

            render json: {status: 0, current_customer_id: customer.customers_id, redirect_path: root_localize_path}

            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "__________________________________________________________________________________________________"
            logger.info "__________________________________________________________________________________________________"
            logger.info "                                                                                                  "
            logger.info " RENDER JSON DATA FOR JAVASCRIPT REDIRECTION TO HOME PAGE                                         "
            logger.info "__________________________________________________________________________________________________"
            logger.info "__________________________________________________________________________________________________"
            logger.info "                                                                                                  "
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"

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

            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "__________________________________________________________________________________________________"
            logger.info "__________________________________________________________________________________________________"
            logger.info "                                                                                                  "
            logger.info " DEVISE SIGN IN CUSTOMER                                                                          "
            logger.info "__________________________________________________________________________________________________"
            logger.info "__________________________________________________________________________________________________"
            logger.info "                                                                                                  "
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"

            render json: {status: 0, current_customer_id: customer.customers_id, redirect_path: root_localize_path}

            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "__________________________________________________________________________________________________"
            logger.info "__________________________________________________________________________________________________"
            logger.info "                                                                                                  "
            logger.info " RENDER JSON DATA FOR JAVASCRIPT REDIRECTION TO HOME PAGE                                         "
            logger.info "__________________________________________________________________________________________________"
            logger.info "__________________________________________________________________________________________________"
            logger.info "                                                                                                  "
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"
            logger.info "##################################################################################################"

          end
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def convert_to_customer
    customer = Customer.find(params[:current_customer])
    if customer.present?
      customer.customers_registration_step = 100
      customer.activation_discount_code_type = 'D'
      customer.customers_abo = 1
      customer.customers_abo_type = 6
      customer.customers_next_abo_type = 6
      customer.tvod_free = 0
      customer.activation_discount_code_id = 0
      if customer.save(validate: false)
        sign_in(customer)
        render json: {status: "TRUE", root: root_localize_path}
      end
    end
  end

  def orange_stop
    customer = Customer.find(params[:current_customer])
    if customer.present?
      customer.customers_abo_auto_stop_next_reconduction = 1
      if customer.save(validate: false)
        sign_in(customer)
        orange_is_eligable_wcf_service = HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangeIsEligable?customersId=#{customer.customers_id}&mobileNumber=#{customer.customers_telephone}&SMSCodeMessage=#{puts t("orange.stop.subscription.sms")}&products_id=-1&locale=#{I18n.locale}")
        if orange_is_eligable_wcf_service.parsed_response == "True"
           render json: {status: "TRUE", msg: "#{t('orange.stop.subscription1')} #{ customer.customers_abo_validityto.strftime("%Y-%m-%d") } #{t('orange.stop.subscription2')}"}
        else
          render json: {status: "TRUE", msg: orange_is_eligable_wcf_service}
        end
      end
    end
  end

  private

  def activation_code_error_message(locale)

    if locale == :fr
      "Le code SMS n'est pas correct."
    elsif locale == :nl
      "SMS code is niet juist."
    elsif locale == :en
      "SMS code is not correct."
    end

  end

end
