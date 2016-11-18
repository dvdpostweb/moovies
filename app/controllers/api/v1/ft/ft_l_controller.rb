class Api::V1::Ft::FtLController < API::V1::BaseController

  def login
    if request.xhr?
      if URI(request.referer).path == "/#{I18n.locale}/freetrial_action" && params[:email].present? && params[:password].present? && params[:code].present?
        resource = Customer.find_for_database_authentication(email: params[:email])
        discount = Discount.find_by_discount_code(params[:code])
        if !resource.discount_reuse?(discount.month_before_reuse) && discount.bypass_discountuse == 0
          render json: { status: 0, message: t("ft_error_page.Forbidden.Register.FTERROR") }
        else
          if resource.valid_password?(params[:password])
            sign_in :customer, resource
            customer = current_customer
            customer.tvod_free = customer.tvod_free + discount.tvod_free
            customer.code = params[:code]
            customer.step = 100
            customer.customers_abo = 1
            customer.customers_abo_validityto = Time.now + 1.month
            if customer.save(validate: false)
              if customer.abo_history(17, customer.abo_type_id, "FREE")
                render json: { status: 1, message: root_localize_path }
              end
            end
          end
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
