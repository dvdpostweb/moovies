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

  def check_activation_code_presence
    if request.xhr?
      code = Activation.find_by_activation_code(params[:code])
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
    	  customer.code = params[:discount_code]
    	  customer.step = discount.goto_step
        if customer.abo_type_id == 6
          customer.tvod_free = customer.tvod_free + discount.tvod_free
        else
          customer.tvod_free = discount.tvod_free
        end
        customer.abo_history(38, customer.abo_type_id, discount.to_param)
    	  if customer.save!
          if DiscountUse.create(:discount_code_id => current_customer.activation_discount_code_id, :customer_id => current_customer.id, :discount_use_date => Time.now.localtime)
            render :json => { :status => 1 }
          end
        else
          render :json => { :status => 0 }
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
