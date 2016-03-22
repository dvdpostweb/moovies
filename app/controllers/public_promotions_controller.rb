class PublicPromotionsController < ApplicationController
  def edit
    render :layout => false
  end

  def update
    discount = Discount.by_name(params[:promotion]).available.first
    activation = Activation.by_name(params[:promotion]).available.first
    if discount.present?
      render :text => new_customer_registration_path(:code => params[:promotion]);
    elsif activation.present?
      if activation.abo_type_id == 0 #carrefour promotion
        render :text => carrefour_path(:carrefour_code => params[:promotion]);
      else
        render :text => new_customer_registration_path(:code => params[:promotion]);
      end
    else
      respond_to do |format|
        format.html {render :text => t('public_promotion.update.error')}
        format.js {render :text => t('public_promotion.update.error')}
      end
    end
  end
end