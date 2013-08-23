class PhoneRequestsController < ApplicationController
  def new
    @phone_request = PhoneRequest.new
  end

  def create
    @phone_request = PhoneRequest.new(params[:phone_request].merge(:customer_id => current_customer ? current_customer.to_param : 0 )) 
    if @phone_request.save
      flash[:notice] = t('messages.index.messages.phone_request_send_successfully')
      redirect_to current_customer ? messages_path : root_localize_path
    else
      #flash[:error] = t('messages.index.messages.phone_request_not_send_successfully')
      render :action => :new
    end
  end
end