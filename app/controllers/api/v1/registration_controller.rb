class Api::V1::RegistrationController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def register
    if request.xhr?
      customer = Customer.new
      customer.email = params[:email] if params[:email].present?
      customer.password = params[:password] if params[:password].present?
      customer.password_confirmation = params[:password_confirmation] if params[:password_confirmation].present?
      customer.customers_abo = 1
      if params[:moovie_id].present?
        product = Product.where(:products_id => params[:moovie_id]).first
        if product
          customer.step = 100
          customer.customers_abo_type = 6
          customer.customers_next_abo_type = 6
          customer.customers_abo_validityto = nil
          customer.preselected_registration_moovie_id = product.to_param
          if customer.save(validate: false)
            sign_in :customer, customer
            redirect_to_product_path = product_path(:id => product.to_param)
            render json: { status: 9, message: redirect_to_product_path }
          end
        end
      elsif !params[:activation].present? && params[:code].present?
        discount = Discount.by_name(params[:code]).available.first
        activation = Activation.by_name(params[:code]).available.first
        customer.customers_registration_step = 100
        customer.activation_discount_code_type = 'A'
        customer.activation_discount_code_id = activation.activation_id
        customer.customers_abo_type = activation.activation_products_id
        customer.customers_next_abo_type = activation.next_abo_type
        customer.group_id = activation.activation_group
        customer.customers_next_discount_code = activation.next_discount
        customer.tvod_free = user.tvod_free + r["tvod_free"]
        if customer.save(validate: false)
          sign_in :customer, customer
          if discount.present?
            DiscountUse.create(:discount_code_id => discount.id, :customer_id => current_customer.to_param, :discount_use_date => Time.now)
          end
          if activation.present?
            activation.update_attributes(:customers_id => current_customer.to_param, :created_at => Time.now.localtime)
          end
          redirect_to_root_path = root_path
          render json: { status: 9, message: redirect_to_root_path }
        end
      elsif params[:activation].present? && params[:code].present?
        discount = Discount.by_name(params[:code]).available.first
        activation = Activation.by_name(params[:activation]).available.first
        customer.registration_code = params[:code]
        if customer.save(validate: false)
          sign_in :customer, customer
          DiscountUse.create(:discount_code_id => discount.id, :customer_id => current_customer.to_param, :discount_use_date => Time.now)
          activation.update_attributes(:customers_id => current_customer.to_param, :created_at => Time.now.localtime)
          redirect_to_root_path = root_path
          render json: { status: 9, message: redirect_to_root_path }
        end
      elsif !params[:activation].present? && !params[:code].present? && !params[:moovie_id].present?
        customer.step = 100
        customer.customers_abo_type = 6
        customer.customers_next_abo_type = 6
        customer.customers_abo_validityto = nil
        if customer.save(validate: false)
          sign_in :customer, customer
          redirect_to_home_path = root_path
          render json: { status: 9, message: redirect_to_home_path }
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
