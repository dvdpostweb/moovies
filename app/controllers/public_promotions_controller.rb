class PublicPromotionsController < ApplicationController

  def edit
    render :layout => false
  end

  def update

    if customer_signed_in?

      if params[:promotion].present?
        activation = Activation.where(:activation_code => params[:promotion]).where(:customers_id => 0).orange.first
        if !activation.present?
          careefour = Activation.where(:activation_code => params[:promotion]).where(:customers_id => 0).where(:activation_group => 21).first
          if careefour.present?
            render :text => carrefour_path(:carrefour_activation_code => params[:promotion]);
          else
            render :text => t('session.error_alreadyused_code')
          end
        elsif activation.present?
          customer = current_customer
          customer.tvod_free = current_customer.tvod_free + activation.tvod_free
          customer.code = params[:promotion]
          customer.step = 100
          customer.customers_abo = 1
          if customer.save!
            current_customer.abo_history(38, current_customer.abo_type_id, activation.to_param)
            activation.update_attributes(:customers_id => current_customer.to_param, :created_at => Time.now.localtime)
            render :text => root_localize_path, notice: t('session.promotion.sucess') and return
          end
        end
      elsif !params[:promotion].present?
        render :text => t('session.error_code_missing')
      end

    else

      discount = Discount.by_name(params[:promotion]).available.first
      activation = Activation.by_name(params[:promotion]).available.first
      if params[:promotion] === "PHOTOBOX"
        render :text => photobox_path(:code => params[:promotion]);
      elsif params[:promotion] === "FREETRIAL"
        render :text => info_path(:page_name => "freetrial");
      elsif params[:promotion] === "CARREFOUR"
        render :text => carrefourbonus_path(:code => params[:promotion]);
      elsif discount.present?
        render :text => new_customer_session_path(:code => params[:promotion]);
      elsif activation.present?
        if activation.abo_type_id == 0 #carrefour promotion
          render :text => carrefour_path(:carrefour_code => params[:promotion]);
        else
          render :text => new_customer_session_path(:code => params[:promotion]);
        end
      else
        respond_to do |format|
          format.html { render :text => t('public_promotion.update.error') }
          format.js { render :text => t('public_promotion.update.error') }
        end
      end

    end

  end

end
