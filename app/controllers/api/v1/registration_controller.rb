class Api::V1::RegistrationController < API::V1::BaseController

  def register
    if request.xhr?
      customer = Customer.new
      customer.email = params[:email] if params[:email].present?
      customer.password = params[:password] if params[:password].present?
      customer.password_confirmation = params[:password_confirmation] if params[:password_confirmation].present?
      customer.customers_abo = 1
      customer.customers_newsletter = params[:customers_newsletter] if params[:customers_newsletter].present?
      customer.customers_newsletterpartner = params[:customers_newsletterpartner] if params[:customers_newsletterpartner].present?
      customer.activation_discount_code_id = 0
      customer.activation_discount_code_type = "D"
      customer.customers_abo_validityto = Time.now
      if params[:moovie_id].present?
        product = Product.where(:products_id => params[:moovie_id]).first
        if product
          customer.step = 100
          customer.customers_abo_type = 6
          customer.customers_next_abo_type = 6
          customer.customers_abo_validityto = nil
          customer.preselected_registration_moovie_id = product.to_param
          if customer.save(validate: false)
            sign_in(customer, bypass: true)
            redirect_to_product_path = edit_customer_payment_methods_path(:customer_id => customer.to_param, :type => :credit_card_tvod, :product_id => product.id, :source => 0)
            render json: { status: 9, message: redirect_to_product_path }
          end
        end
      elsif !params[:activation].present? && params[:code].present?

        aqueryold = <<-SQL
        SELECT activation_id, activation_products_id, next_abo_type, activation_group, next_discount, tvod_free
        FROM activation_code
        WHERE activation_code='#{params[:code]}'
        SQL
        aresold = ActiveRecord::Base.connection.exec_query(aqueryold)

        dqueryold = <<-SQL
        SELECT discount_code_id, listing_products_allowed, next_abo_type, group_id, tvod_free, goto_step
        FROM discount_code
        WHERE discount_code='#{params[:code]}'
        SQL
        dresold = ActiveRecord::Base.connection.exec_query(dqueryold)

        if aresold.present?
          aresold.each do |r|
            customer.customers_registration_step = 100
            customer.activation_discount_code_type = 'A'
            customer.activation_discount_code_id = r["activation_id"]
            customer.customers_abo_type = r["activation_products_id"]
            customer.customers_next_abo_type = r["next_abo_type"]
            customer.group_id = r["activation_group"]
            customer.customers_next_discount_code = r["next_discount"]
            customer.tvod_free = r["tvod_free"]
            if customer.save(:validate => false)
              sign_in(customer, bypass: true)
              activation = Activation.find_by_activation_code(params[:code])
              activation.update_attributes(:customers_id => customer.to_param, :created_at => Time.now.localtime)
              redirect_to_root_path = root_localize_path
              render json: { status: 9, message: redirect_to_root_path }
            else
              flash[:error] = "Error while creating a user account. Please try again."
              redirect_to root_url
            end
          end
        end

        if dresold.present?
          dresold.each do |r|
            customer.customers_registration_step = r["goto_step"]
            customer.activation_discount_code_type = 'D'
            customer.activation_discount_code_id = r["discount_code_id"]
            customer.customers_abo_type = r["listing_products_allowed"]
            customer.customers_next_abo_type = r["next_abo_type"]
            customer.group_id = r["group_id"]
            customer.tvod_free = r["tvod_free"]
            if customer.save(:validate => false)
              sign_in(customer, bypass: true)
              DiscountUse.create(:discount_code_id => r["discount_code_id"], :customer_id => customer.to_param, :discount_use_date => Time.now)
              redirect_to_root_path = root_localize_path
              render json: { status: 9, message: redirect_to_root_path }
            else
              flash[:error] = "Error while creating a user account. Please try again."
              redirect_to root_url
            end
          end
        end

      elsif params[:activation].present? && params[:code].present?
        discount = Discount.by_name(params[:code]).available.first
        activation = Activation.by_name(params[:activation]).available.first
        customer.registration_code = params[:code]
        if customer.save(validate: false)
          sign_in(customer, bypass: true)
          DiscountUse.create(:discount_code_id => discount.id, :customer_id => current_customer.to_param, :discount_use_date => Time.now)
          activation.update_attributes(:customers_id => current_customer.to_param, :created_at => Time.now.localtime)
          redirect_to_root_path = root_localize_path
          render json: { status: 9, message: redirect_to_root_path }
        end
      elsif !params[:activation].present? && !params[:code].present? && !params[:moovie_id].present?
        customer.step = 100
        customer.customers_abo_type = 6
        customer.customers_next_abo_type = 6
        customer.customers_abo_validityto = nil
        if customer.save(validate: false)
          sign_in(customer, bypass: true)
          redirect_to_home_path = root_localize_path
          render json: { status: 9, message: redirect_to_home_path }
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
