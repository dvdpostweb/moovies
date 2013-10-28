class PhoneRequestsController < ApplicationController
  def index
    redirect_to new_phone_request_path
  end
  def new
    @meta_title = t("phone_request.new.meta_title", :default => '')
    @meta_description = t("phone_request.new.meta_description", :default => '')
    unless current_customer
      if params[:kind] == :adult
        @discount_top = Discount.find(Moovies.discount["contact_adult_#{I18n.locale}"])
      else
        @discount_top = Discount.find(Moovies.discount["contact_#{I18n.locale}"])
      end
    end
    @phone_request = PhoneRequest.new
  end

  def create
    @meta_title = t("phone_request.new.meta_title", :default => '')
    @meta_description = t("phone_request.new.meta_description", :default => '')
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