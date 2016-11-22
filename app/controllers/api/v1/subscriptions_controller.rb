class Api::V1::SubscriptionsController < API::V1::BaseController

  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_customer!
  protect_from_forgery except: [:for_logedin_customers]

  def for_logedin_customers
    if params[:code].present?
      discount = Discount.find_by_discount_code(params[:code])
      customer = current_customer
      if !customer.payable?
        customer.code = params[:code]
        customer.step = 33
        customer.customers_abo = 1
        customer.tvod_free = discount.tvod_free
        if customer.save(validate: false)
          if customer.abo_history(6, customer.abo_type_id, discount.to_param)
            if customer.set_privilegies?
              redirect_to step_path(:id => 'step3')
            end
          end
        end
      else
        if customer.customers_locked__for_reconduction == 1 || current_customer.tvod_free > 0
          redirect_to :back
          flash[:error] = t('streaming_products.renew_subscription_error')
        else
          customer.code = params[:code]
          customer.step = 100
          customer.customers_abo = 1
          customer.tvod_free = customer.tvod_free + discount.tvod_free
#          customer.customers_abo_validityto = Time.now
#          customer.customers_locked__for_reconduction = 1
#          customer.credits_already_recieved = 1
          if customer.save(validate: false)
            if customer.abo_history(6, customer.abo_type_id, discount.to_param)
              if customer.set_privilegies?
                redirect_to root_localize_path
              end
            end
          end
        end
      end
    end
  end

end
