class Api::V1::Ft::FtRController < API::V1::BaseController

  def register
    if request.xhr?
      if URI(request.referer).path == "/#{I18n.locale}/freetrial_action" && params[:email].present? && params[:password].present? && params[:password_confirmation] && params[:code].present?
        customer = Customer.new
        customer.email = params[:email]
        customer.password = params[:password]
        customer.password_confirmation = params[:password]
        customer.customers_newsletter = params[:customers_newsletter] if params[:customers_newsletter].present?
        customer.customers_newsletterpartner = params[:customers_newsletterpartner] if params[:customers_newsletterpartner].present?
        customer.registration_code_freetrialR = params[:code]
        if customer.save(validate: false)
        #  if customer.set_privilegies?
            sign_in :customer, customer
            discount = Discount.find_by_discount_code(params[:code])
            if DiscountUse.create(:discount_code_id => discount.id, :customer_id => customer.to_param, :discount_use_date => Time.now)
              render json: { status: 1, message: step_path(:id => 'step3', :locale => cookies[:locale]) }
            end
        #  end
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
