class Customers::SessionsController < Devise::SessionsController
  def new
    @meta_title = t("sessions.new.meta_title", :default => '')
    @meta_description = t("sessions.new.meta_description", :default => '')
    super
  end
  
  def create
    @meta_title = t("sessions.new.meta_title", :default => '')
    @meta_description = t("sessions.new.meta_description", :default => '')
    code = params[:code]
    if code
      @discount = Discount.by_name(code).available.first
      @activation = Activation.by_name(code).available.first
      if @discount.nil? && @activation.nil?
        redirect_to params[:return_url], :alert => 'code errone' and return
      else
        if current_customer.abo_active == 0
          customer = current_customer
          customer.step = 31
          customer.code = code
          customer.save(:validate => false)
        end
      end
    end
    super
  end
end