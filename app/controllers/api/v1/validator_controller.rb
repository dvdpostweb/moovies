class Api::V1::ValidatorController < ApplicationController

  def check_presence_of_customer_email
    if request.xhr?
      email = Customer.find_by_email(params[:customer][:email])
      if email.present?
        render json: TRUE
      else
        render json: FALSE
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def check_presence_of_customer_email_registration
    if request.xhr?
      email = Customer.find_by_email(params[:customer][:email])
      if email.present?
        render json: FALSE
      else
        render json: TRUE
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def check_activation_code_presence
    if request.xhr?
      code = Activation.where(:activation_code => params[:code]).where(:customers_id => 0).orange.first
      if code.present?
        render json: TRUE
      else
        render json: FALSE
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def check_activation_code_presence_carrefour
    if request.xhr?
      code = Activation.where(:activation_code => params[:carrefour_code]).where(:customers_id => 0).where(:activation_group => 21).first
      if code.present?
        render json: TRUE
      else
        render json: FALSE
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def set_plan
    if request.xhr?
      if params[:discount_code].present?
        discount = Discount.find_by_discount_code(params[:discount_code])
    	  customer = current_customer
        if !customer.discount_reuse?(discount.month_before_reuse) && discount.bypass_discountuse == 0
          render :json => { :status => 2 }
        else
          customer.code = params[:discount_code]
          customer.step = discount.goto_step
          customer.customers_abo = 1
          customer.tvod_free = customer.tvod_free + discount.tvod_free
          customer.abo_history(38, customer.abo_type_id, discount.to_param)
          if customer.save!
            if DiscountUse.create(:discount_code_id => current_customer.activation_discount_code_id, :customer_id => current_customer.id, :discount_use_date => Time.now.localtime)
              render :json => { :status => 1 }
            end
          else
            render :json => { :status => 0 }
          end
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def check_and_validate_public_promotions_activation_codes
    if customer_signed_in?
      if request.xhr?
        if params[:promotion].present?
          activation = Activation.where(:activation_code => params[:promotion]).where(:customers_id => 0).orange.first
          if !activation.present?
            careefour = Activation.where(:activation_code => params[:promotion]).where(:customers_id => 0).where(:activation_group => 21).first
            if careefour.present?
              render :json => { :status => 2, :message => carrefour_path(:carrefour_activation_code => params[:promotion]) }
            else
              render :json => { :status => 1, :message => t('session.error_alreadyused_code') }
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
              render :json => { :status => 2, :message => root_localize_path }
            end
          end
        elsif !params[:promotion].present?
          render :json => { :status => 1, :message => t('session.error_code_missing') }
        end
      else
        raise ActionController::RoutingError.new('Not Found')
      end
    else
      if request.xhr?
        discount = Discount.by_name(params[:promotion]).available.first
        activation = Activation.by_name(params[:promotion]).available.first
        if params[:promotion] === "PHOTOBOX"
          render :json => { :status => 2, :message => photobox_path(:code => params[:promotion]) }
        elsif params[:promotion] === "FREETRIAL"
          render :json => { :status => 2, :message => info_path(:page_name => "freetrial") }
        elsif params[:promotion] === "CARREFOUR"
          render :json => { :status => 2, :message => carrefourbonus_path(:code => params[:promotion]) }
        elsif discount.present?
          render :text => new_customer_session_path(:code => params[:promotion]);
        elsif activation.present?
          if activation.abo_type_id == 0 
            render :json => { :status => 2, :message => carrefour_path(:carrefour_code => params[:promotion]) }
          else
            render :json => { :status => 2, :message => new_customer_session_path(:code => params[:promotion]) }
          end
        else
          render :json => { :status => 1, :message => t('public_promotion.update.error') }
        end
      else
        raise ActionController::RoutingError.new('Not Found')
      end
    end
  end

end
