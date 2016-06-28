class PublicPromotionsController < ApplicationController

  def edit
    render :layout => false
  end

  def update
    discount = Discount.by_name(params[:promotion]).available.first
    activation = Activation.by_name(params[:promotion]).available.first
    if params[:promotion] === "PHOTOBOX"
      render :text => photobox_path(:code => params[:promotion]);
    elsif params[:promotion] === "FREETRIAL"
      #render :text => freetrial_path(:code => params[:promotion]);
      render :text => info_path(:page_name => "freetrial")
    elsif params[:promotion] === "CARREFOUR"
      render :text => carrefourbonus_path(:code => params[:promotion]);
    elsif params[:promotion] === "POPAC"
      render :text => "POPAC"
    elsif discount.present?
      render :text => customers_reactive_path(:code => params[:promotion]);
    elsif activation.present?
      if activation.abo_type_id == 0 #carrefour promotion
        render :text => carrefour_path(:carrefour_code => params[:promotion]);
      else
        render :text => customers_reactive_path(:code => params[:promotion]);
      end
    else
      respond_to do |format|
        format.html {render :text => t('public_promotion.update.error')}
        format.js {render :text => t('public_promotion.update.error')}
      end
    end
  end
end