class Customers::SessionsController < Devise::SessionsController
  def new
    @meta_title = t("sessions.new.meta_title", :default => '')
    @meta_description = t("sessions.new.meta_description", :default => '')
    super
    if current_customer && params[:customer] && params[:customer][:code]
      customer = current_customer
      customer.code = params[:customer][:code]
      customer.save
    end
  end
  
  def create
    @meta_title = t("sessions.new.meta_title", :default => '')
    @meta_description = t("sessions.new.meta_description", :default => '')
    super
  end
end