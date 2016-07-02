class Api::V1::LoginController < ApplicationController

  def login
    if request.xhr?
      resource = Customer.find_for_database_authentication(email: params[:email])
      if params[:email].present? && params[:password].present? && !params[:code].present?
        return invalid_login_attempt unless resource
        if resource.valid_password?(params[:password])
          sign_in :customer, resource
          return render json: { status: 1, message: "login_action_success" }
        end
        invalid_login_attempt
      elsif params[:email].present? && params[:password].present? && params[:code].present?
        if !resource.valid_password?(params[:password])
          invalid_login_attempt
        elsif (activation = Activation.find_by_activation_code(params[:code]))
          customer = Customer.find_by_activation_discount_code_id(activation.id)
          @customer = Customer.find_by_email(params[:email])
          resource_activation = Customer.find_for_database_authentication(email: params[:email])
          if customer.present? || activation.activation_code_validto_date < Date.today
            render json: { status: 3, message: arleady_used_code_messages }
          else
            @customer.tvod_free = @customer.tvod_free + activation.tvod_free if @customer.abo_type_id == 6
            @customer.abo_history(38, @customer.abo_type_id, activation.to_param)
            @customer.code = params[:code]
            @customer.step = 33
            if @customer.save!
              if activation.update_attributes(:customers_id => @customer.to_param, :created_at => Time.now.localtime)
                if resource_activation.valid_password?(params[:password])
                  sign_in :customer, resource_activation
                  return render json: { status: 4 }
                end
              end
            end
          end
        elsif (discount = Discount.find_by_discount_code(params[:code]))
          if discount.discount_status == 0
            render json: { status: 5, message: arleady_used_code_messages }
          else
            customer = Customer.find_by_email(params[:email])
            resource_discount = Customer.find_for_database_authentication(email: params[:email])
            customer.tvod_free = customer.tvod_free + activation.tvod_free if customer.abo_type_id == 6
            customer.abo_history(38, customer.abo_type_id, discount.to_param)
            customer.code = params[:code]
            customer.step = 33
            if customer.save!
              if DiscountUse.create(:discount_code_id => discount.id, :customer_id => customer.to_param, :discount_use_date => Time.now)
                if resource_discount.valid_password?(params[:password])
                  sign_in :customer, resource_discount
                  return render json: { status: 4 }
                end
              end
            end
          end
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
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

