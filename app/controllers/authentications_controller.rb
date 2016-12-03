class AuthenticationsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    params = request.env["omniauth.params"]
    customer = Customer.find_by_email(auth['extra']['raw_info']['email'])
    product = Product.where(:products_id  => params["moovie_id"]).first
    discount = Discount.by_name(params["code"]).first
    activation = Activation.by_name(params["code"]).first


    if customer.present?
      if product.present? && !params["moovie_id"].blank?
        sign_in(:customer, customer)
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
        logger.info "NORMAL LOGIN FOR FB USER #{customer.email} with product path #{product_path(:id => product.to_param)}"
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
        redirect_to product_path(:id => product.to_param)
      elsif discount.present? && !params["code"].blank?
        if !customer.discount_reuse?(discount.month_before_reuse) && discount.bypass_discountuse == 0
          if params["ACTION_TYPE"].present? && params["ACTION_TYPE"] == "FREETRIAL"
            redirect_to freetrial_action_path(:code => code, :freetrial_action => params["freetrial_action"], :films => params["films"], :price => params["price"], :FT_CODE_RESTRICTION => "FTC_ERROR")
          elsif params["ACTION_TYPE"].present? && params["ACTION_TYPE"] == "NORMAL"
            redirect_to "#{params["ORG_URL"]};DS_CODE_RESTRICTION_ERROR=DISCOUNT_CODE_LIMIT_AUTH_ERROR"
          end
        else
          discount_code_account_activation_facebook(discount, customer, activation)
        end
      elsif activation.present? && !params["code"].blank?
        activation_code_account_activation_facebook(activation, customer, params["code"])
      else
        sign_in(:customer, customer)
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
        logger.info "                      NORMAL LOGIN FOR FB USER #{customer.email}                                  "
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
        redirect_to root_localize_path
      end
    else
      if product.present? && !params["moovie_id"].blank?
        customer = Customer.new
        customer.apply_omniauth(auth)
        customer.step = 100
        customer.customers_abo = 1
        customer.customers_abo_type = 6
        customer.customers_next_abo_type = 6
        customer.customers_abo_validityto = nil
        customer.activation_discount_code_type = "D"
        customer.preselected_registration_moovie_id = product.to_param
        if customer.save(:validate => false)
          if customer.set_privilegies?
            sign_in(:customer, customer)
            redirect_to edit_customer_payment_methods_path(:customer_id => customer.to_param, :type => :credit_card_tvod, :product_id => product.id, :source => 0)
          end
        end
      elsif discount.present? && !params["code"].blank?
        customer = Customer.new
        customer.apply_omniauth(auth)
        customer.tvod_free = discount.tvod_free
        customer.code = params[:code]
        customer.step = discount.goto_step
        customer.customers_abo = 1
        if customer.save(validate: false) && customer.set_privilegies? && customer.abo_history(38, customer.abo_type_id, discount.to_param)
          if DiscountUse.create(:discount_code_id => discount.id, :customer_id => customer.to_param, :discount_use_date => Time.now)
            sign_in :customer, customer
            if activation
              activation.update_attributes(:customers_id => customer.to_param, :created_at => Time.now.localtime)
            end
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
            logger.info "          REG D FOR FB USER #{customer.email} WITH DISCOUNT CODE #{params["code"]}                "
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
            redirect_to root_localize_path
          end
        end
      elsif activation.present? && !params["code"].blank?
        customer = Customer.new
        customer.apply_omniauth(auth)
        customer.customers_registration_step = 100
        customer.activation_discount_code_type = 'A'
        customer.activation_discount_code_id = activation.activation_id
        customer.customers_abo_type = activation.activation_products_id
        customer.customers_next_abo_type = activation.next_abo_type
        customer.group_id = activation.activation_group
        customer.customers_next_discount_code = activation.next_discount
        if customer.save(validate: false) && customer.set_privilegies?
          customer.tvod_free = activation.tvod_free
          if customer.save(validate: false)
            if activation.update_attributes(:customers_id => customer.to_param, :created_at => Time.now.localtime)
              if customer.abo_history(38, customer.abo_type_id, activation.to_param)
                sign_in :customer, customer
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
                logger.info "         REG A FOR FB USER #{customer.email} WITH ACTIVATION CODE #{params["code"]}                         "
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
                redirect_to root_localize_path
              end
            end
          end
        end
      else
        customer = Customer.new
        customer.apply_omniauth(auth)
        customer.step = 100
        customer.customers_abo = 1
        customer.customers_abo_type = 6
        customer.customers_next_abo_type = 6
        customer.customers_abo_validityto = nil
        customer.activation_discount_code_type = "D"
        if customer.save(:validate => false)
          if customer.set_privilegies?
            sign_in(:customer, customer)
            redirect_to root_localize_path
          end
        end
      end

    end

  end

  private

  def activation_code_account_activation_facebook(activation, customer, code)
    customer.customers_registration_step = 100
    customer.activation_discount_code_type = 'A'
    customer.activation_discount_code_id = activation.activation_id
    customer.customers_abo_type = activation.activation_products_id
    customer.customers_next_abo_type = activation.next_abo_type
    customer.group_id = activation.activation_group
    customer.customers_next_discount_code = activation.next_discount
    if customer.save(validate: false) && customer.set_privilegies?
      customer.tvod_free = customer.tvod_free + activation.tvod_free
      if customer.save(validate: false)
        if activation.update_attributes(:customers_id => customer.to_param, :created_at => Time.now.localtime)
          if customer.abo_history(38, customer.abo_type_id, activation.to_param)
            sign_in :customer, customer
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
            logger.info "         NORMAL LOGIN FOR FB USER #{customer.email} WITH ACTIVATION CODE #{code}                  "
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
            redirect_to root_localize_path
          end
        end
      end
    end
  end

  def discount_code_account_activation_facebook(discount, customer, activation = nil)
    customer.tvod_free = customer.tvod_free + discount.tvod_free
    customer.code = params[:code]
    customer.step = discount.goto_step
    customer.customers_abo = 1
    if customer.save! && customer.set_privilegies? && customer.abo_history(38, customer.abo_type_id, discount.to_param)
      if DiscountUse.create(:discount_code_id => discount.id, :customer_id => customer.to_param, :discount_use_date => Time.now)
        sign_in :customer, customer
        if activation
          activation.update_attributes(:customers_id => customer.to_param, :created_at => Time.now.localtime)
        end
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
        logger.info "         NORMAL LOGIN FOR FB USER #{customer.email} WITH DISCOUNT CODE #{params["code"]}                  "
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
        redirect_to root_localize_path
      end
    end
  end

end
