class SubscriptionsController < ApplicationController
  before_filter :authenticate_customer!
  def update
    if !current_customer.tvod_only? && (current_customer.group_id == 2 || !current_customer.payable? || current_customer.locked == 1)
      redirect_to root_localize_path() and return
    end
    if params[:abo_id]
      new_abo = SubscriptionType.find(params[:abo_id])
      current_customer.locked = 1
      if current_customer.tvod_only?
        current_customer.abo_type_id = params[:abo_id]
        current_customer.next_abo_type_id = params[:abo_id]
        current_customer.step = 31
        action = Subscription.action[:tvod_init_sub]
      else
        current_customer.next_abo_type_id = params[:abo_id]
        if current_customer.subscription_type.package_count.to_i < new_abo.package_count.to_i
          action = Subscription.action[:abo_upgrade]
          current_customer.abo_type_id = params[:abo_id]
        else 
          action = Subscription.action[:abo_downgrade]
        end
      end
      current_customer.save(validate: false)
      current_customer.abo_history(action, params[:abo_id])
      redirect_to root_localize_path(), :notice => t('subscription.update.abo_success', :abo => current_customer.next_subscription_type.description )
    else
      redirect_to info_path(:page_name => t('routes.infos.params.abo')), :alert => t('subscription.update.error_abo')
    end
  end
end