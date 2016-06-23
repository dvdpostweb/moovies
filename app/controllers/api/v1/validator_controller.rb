class Api::V1::ValidatorController < ApplicationController

  def check_presence_of_customer_email
    email = Customer.find_by_email(params[:customer][:email])
    if email.present?
      render json: TRUE
    else
      render json: FALSE
    end
  end

  def set_plan
    if params[:customer_email].present? && params[:discount_code].present?
      discount = Discount.find_by_discount_code(params[:discount_code])
  	  customer = Customer.find_by_email(params[:customer_email])
  	  customer.code = params[:discount_code]
  	  customer.step = 33
      #customer.abo_history(action, customer.abo_type_id)
      DiscountUse.create(:discount_code_id => discount.id, :customer_id => customer.to_param, :discount_use_date => Time.now.localtime)
  	  if customer.save!
        render :json => { :status => 1 }
      else
        render :json => { :status => 0 }
      end
    end
  end

end
