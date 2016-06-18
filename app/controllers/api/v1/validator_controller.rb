class Api::V1::ValidatorController < ApplicationController

  def check_presence_of_customer_email
    email = Customer.find_by_email(params[:customer][:email])
    if email.present?
      render json: TRUE
    else
      render json: FALSE
    end
  end

end