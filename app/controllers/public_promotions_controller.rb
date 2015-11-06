class PublicPromotionsController < ApplicationController
  def edit
    render :layout => false
  end

  def update
    discount = Discount.by_name(params[:promotion]).available
    activation = Activation.by_name(params[:promotion]).available
    if !discount.empty?
      render :text => new_customer_registration_path(:code => params[:promotion]);
    elsif !activation.empty?
      render :text => new_customer_registration_path(:code => params[:promotion]);
    else
      respond_to do |format|
        format.html {render :text => t('.public_promotion.update.error')}
        format.js {render :text => t('.public_promotion.update.error')}
      end
    end
  end
end