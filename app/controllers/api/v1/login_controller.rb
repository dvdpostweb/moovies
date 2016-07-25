class Api::V1::LoginController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def login
    if request.xhr?
      resource = Customer.find_for_database_authentication(email: params[:email])
      if params[:email].present? && params[:password].present? && !params[:code].present?
        if !resource.valid_password?(params[:password])
          invalid_login_attempt
        else
          regular_login(resource, params[:email], params[:password], (params[:moovie_id] if params[:moovie_id].present?))
        end
      elsif params[:email].present? && params[:password].present? && params[:code].present?
        if !resource.valid_password?(params[:password])
          invalid_login_attempt
        elsif (activation = Activation.find_by_activation_code(params[:code]))
          activation_code_account_activation(activation, resource, params[:password])
        elsif (discount = Discount.find_by_discount_code(params[:code]))
          discount_code_account_activation(discount, resource, params[:password], (params[:activation] if params[:activation].present?))
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  private

  def activation_code_account_activation(activation, resource, password)
    #if resource.abo_type_id == 6
    resource.tvod_free = resource.tvod_free + activation.tvod_free
    #else
    #  resource.tvod_free = activation.tvod_free
    #end
    resource.abo_history(38, resource.abo_type_id, activation.to_param)
    resource.code = params[:code]
    resource.customers_abo = 1
    if resource.abo_type_id != 6
      resource.step = 33
    end
    if resource.save!
      if activation.update_attributes(:customers_id => resource.to_param, :created_at => Time.now.localtime)
        if resource.valid_password?(password)
          sign_in :customer, resource
          success_activation_message
        end
      end
    end
  end

  def discount_code_account_activation(discount, resource, password, activation = nil)
    activation = Activation.by_name(activation).available.first
    if discount.discount_status == 0
      invalid_discount_code_message
    else
      #if resource.abo_type_id == 6
      resource.tvod_free = resource.tvod_free + discount.tvod_free
      #else
      #  resource.tvod_free = discount.tvod_free
      #end
      resource.abo_history(38, resource.abo_type_id, discount.to_param)
      resource.code = params[:code]
      resource.step = discount.goto_step
      resource.customers_abo = 1
      if resource.save!
        if DiscountUse.create(:discount_code_id => discount.id, :customer_id => resource.to_param, :discount_use_date => Time.now)
          if resource.valid_password?(password)
            sign_in :customer, resource
            if activation
              activation.update_attributes(:customers_id => current_customer.to_param, :created_at => Time.now.localtime)
            end
            success_activation_message
          end
        end
      end
    end
  end

  def regular_login(resource, email, password, moovie_id = nil)
    if resource.valid_password?(password)
      if moovie_id.present?
        sign_in :customer, resource
        customer = current_customer
        customer.preselected_registration_moovie_id = moovie_id
        if customer.save(validate: false)
          product = Product.where(:products_id => current_customer.preselected_registration_moovie_id).first
          redirect_to_product_path = product_path(:id => product.to_param)
          render json: { status: 1, message: redirect_to_product_path }
        end
      else
        sign_in :customer, resource
        if current_customer.preselected_registration_moovie_id? && current_customer.step == 100 # && current_customer.payment_method == 0
          p = Product.where(:products_id => current_customer.preselected_moovie).first
          if p.present?
            redirect_to_p_path = product_path(:id => p.to_param)
            render json: { status: 1, message: redirect_to_p_path }
          else
            redirect_to_root_localize_path = root_localize_path
            render json: { status: 1, message: redirect_to_root_localize_path }
          end
        else #if current_customer.preselected_registration_moovie_id == 0 && current_customer.step == 100
          redirect_to_root_localize_path = root_localize_path
          render json: { status: 1, message: redirect_to_root_localize_path }
        end
      end
    end
  end

  def success_activation_message
    return render json: { status: 4 }
  end

  def success_login_message
    return render json: { status: 1, message: "login_action_success" }
  end

  def invalid_discount_code_message
    render json: { status: 5, message: arleady_used_code_messages }
  end

  def invalid_activation_code_message
    render json: { status: 3, message: arleady_used_code_messages }
  end

  def invalid_login_attempt
    render json: { status: 0, message: password_message }
  end

  def password_message
    return "Votre mot de passe est incorrect" if I18n.locale == :fr
    return "Uw wachtwoord is onjuist" if I18n.locale == :nl
    return "Your password is incorrect" if I18n.locale == :en
  end

  def arleady_used_code_messages
    return "Le code est pas valide" if I18n.locale == :fr
    return "De code is niet geldig" if I18n.locale == :nl
    return "The code is not valid" if I18n.locale == :en
  end

end
