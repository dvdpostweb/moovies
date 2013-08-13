class StepsController < ApplicationController
  before_filter :authenticate_customer!, :unless => :confirmation?
  def index
    @body_id = params[:page_name]
    if params[:page_name] == 'step2'
      current_customer.build_address unless current_customer.address
      @countries = Country.all
      @hide_footer = true
      @hide_menu = true
    elsif params[:page_name] == 'step3'
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
    
  end

  protected
  def confirmation?
    params[:page_name] == 'confirm'
  end
end
