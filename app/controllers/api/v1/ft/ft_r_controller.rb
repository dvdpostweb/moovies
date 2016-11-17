class Api::V1::Ft::FtRController < API::V1::BaseController

  def register
    if request.xhr?
      if URI(request.referer).path == "/#{I18n.locale}/freetrial_action" && params[:email].present? && params[:password].present? && params[:password_confirmation].present? && params[:code].present?
        customer = Customer.new
        customer.email = params[:email] if params[:email].present?
        customer.password = params[:password] if params[:password].present?
        customer.password_confirmation = params[:password_confirmation] if params[:password_confirmation].present?
        #customer.customers_newsletter = params[:customers_newsletter] if params[:customers_newsletter].present?
        #customer.customers_newsletterpartner = params[:customers_newsletterpartner] if params[:customers_newsletterpartner].present?
        customer.step = 33
        customer.code = params[:code] if params[:code].present?
        if customer.save(validate: false)
          sign_in :customer, customer
          discount = Discount.find_by_discount_code(params[:code])
          if DiscountUse.create(:discount_code_id => discount.id, :customer_id => customer.to_param, :discount_use_date => Time.now)
            locale = customer.locale || :fr
            render json: { status: 1, message: step_path(:id => 'step3', :locale => locale) }
          end
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
