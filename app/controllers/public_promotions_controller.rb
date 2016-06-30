class PublicPromotionsController < ApplicationController

  def edit
    render :layout => false
  end

   def update

    if customer_signed_in?

      if params[:promotion].present?
        if activation = Activation.find_by_activation_code(params[:promotion])
          code = Customer.find_by_activation_discount_code_id(activation.id)
          if customer_signed_in?
            if code.present? || activation.activation_code_validto_date < Date.today
              render :text => t('session.error_alreadyused_code')
            else
              customer = current_customer
              customer.tvod_free = current_customer.tvod_free + activation.tvod_free if current_customer.tvod_only?
              customer.code = params[:promotion]
              if customer.save!
                current_customer.abo_history(38, current_customer.abo_type_id, activation.to_param)
                activation.update_attributes(:customers_id => current_customer.to_param, :created_at => Time.now.localtime)
                render :text => root_localize_path, notice: t('session.promotion.sucess') and return
              end
            end
          end
        else
          render :text => t('session.error_code_not_present')
        end
      else
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

end