class RenewMonthlySubscriptionController < ApplicationController

  def renew_monthly_credits_for_a_la_carte
    if current_customer.customers_locked__for_reconduction == 1 || current_customer.tvod_free > 0
      redirect_to :back
      flash[:error] = t('streaming_products.renew_subscription_error')
    else
      product_abo = ProductAbo.find_by_products_id(current_customer.customers_next_abo_type)
      customer = current_customer
      customer.tvod_free = current_customer.tvod_free + product_abo.tvod_credits
#      customer.customers_abo_validityto = Time.now
#      customer.customers_locked__for_reconduction = 1
#      customer.credits_already_recieved = 1
      if customer.save(validate: false)
        if customer.set_privilegies?
          if params[:product].present?
            redirect_to product_path(:id => params[:product])
          else
            redirect_to :back
          end
        end
      end
    end
  end

end
