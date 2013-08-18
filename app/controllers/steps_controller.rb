class StepsController < ApplicationController
  before_filter :authenticate_customer!, :unless => :confirmation?
  def show
    @body_id = params[:id]
    if params[:id] == 'step2'
      current_customer.build_address unless current_customer.address
      @countries = Country.all
      @hide_footer = true
      @hide_menu = true
    elsif params[:id] == 'step3'
      if current_customer.promo_type == 'D'
        @promo = Discount.find(current_customer.promo_id)
      else
        @promo = Activation.find(current_customer.promo_id)
      end
      @hide_footer = true
      @hide_menu = true
    end
  end

  def update
    if params[:id] == 'step3'
      current_customer.update_column(:customers_registration_step, 31)
    end
    redirect_after_registration(customer_path)
  end

  protected
  def confirmation?
    params[:id] == 'confirm'
  end
end
