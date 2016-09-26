class SubscriptionsController < ApplicationController
  before_filter :authenticate_customer!

  def update
    if !current_customer.tvod_only? && (current_customer.group_id == 2 || !current_customer.payable? || current_customer.locked == 1)
      redirect_to root_localize_path() and return
    end

    #current_customer.locked = 1
    if current_customer.tvod_only? && params[:code]
      @discount = Discount.by_name(params[:code]).available.first
      if @discount
        current_customer.abo_type_id = @discount.abo_type_id
        current_customer.next_abo_type_id = @discount.next_abo_type_id
        current_customer.step = @discount.goto_step
        current_customer.promo_type = 'D'
        current_customer.promo_id = @discount.id
        current_customer.abo_active = 0
        action = Subscription.action[:tvod_init_sub]
      else
        redirect_to info_path(:page_name => t('routes.infos.params.abo')), :alert => t('subscription.update.error_abo')
      end
    elsif params[:abo_id]
      new_abo = SubscriptionType.find(params[:abo_id])
      current_customer.next_abo_type_id = params[:abo_id]
      if current_customer.subscription_type.package_count.to_i < new_abo.package_count.to_i
        action = Subscription.action[:abo_upgrade]
        current_customer.abo_type_id = params[:abo_id]
      else
        action = Subscription.action[:abo_downgrade]
      end
    else
      redirect_to info_path(:page_name => t('routes.infos.params.abo')), :alert => t('subscription.update.error_abo')
    end
    current_customer.save(validate: false)
    current_customer.abo_history(action, params[:abo_id])
    redirect_to info_path(:page_name => t('routes.infos.params.abo')), :notice => t('subscription.update.abo_success', :abo => current_customer.next_subscription_type.description)
  end
end