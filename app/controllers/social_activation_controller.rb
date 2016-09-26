class SocialActivationController < ApplicationController
  before_filter :authenticate_customer!

  def activate
    if params[:customer_email].present? && params[:activation_dicsount_code_id].present? && params[:customers_abo_type].present? && params[:customers_next_abo_type].present? && params[:tvod_free].present?
      customer = Customer.find_by_email(params[:customer_email])
      customer.activation_discount_code_id = params[:activation_dicsount_code_id]
      customer.customers_abo_type = params[:customers_abo_type]
      customer.customers_next_abo_type = params[:customers_next_abo_type]
      customer.tvod_free = params[:tvod_free]
      customer.customers_registration_step = 33
      customer.facebook_activation = 1
      if customer.save!
        render :json => {:status => 1}
      else
        render :json => {:status => 0}
      end
    end
  end
end
