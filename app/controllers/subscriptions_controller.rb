class SubscriptionsController < ApplicationController
  before_filter :authenticate_customer!
  def update
    if current_customer.group_id == 2 || !current_customer.payable? || current_customer.locked == 1
      redirect_to root_localize_path() and return
    end
    if params[:abo_id]
      new_abo = SubscriptionType.find(params[:abo_id])
      current_customer.locked = 1
      current_customer.next_abo_type_id = params[:abo_id]
      if current_customer.subscription_type.package_count.to_i < new_abo.package_count.to_i
        action = Subscription.action[:abo_upgrade]
        current_customer.abo_type_id = params[:abo_id]
      else 
        action = Subscription.action[:abo_downgrade]
      end
      current_customer.save(validate: false)
      current_customer.abo_history(action, params[:abo_id])
      redirect_to info_path(:page_name => :abo)
    else
      redirect_to info_path(:page_name => :abo), :alert => t('.error_abo')
    end
  end
end