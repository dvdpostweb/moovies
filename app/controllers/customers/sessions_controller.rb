class Customers::SessionsController < Devise::SessionsController
  def new
    @meta_title = t("sessions.new.meta_title", :default => '')
    @meta_description = t("sessions.new.meta_description", :default => '')
    super
  end
  
  def create
    @checked = params[:marketing] == "1" ? true : false
    @meta_title = t("sessions.new.meta_title", :default => '')
    @meta_description = t("sessions.new.meta_description", :default => '')
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    
    sign_in(resource_name, resource)

    code = params[:code]
    if code
      @discount = Discount.by_name(code).available.first
      @activation = Activation.by_name(code).available.first
      if @discount.nil? && @activation.nil?
        redirect_to params[:return_url], :alert => 'wrong code' and return
      else
        if current_customer.abo_active == 0
          customer = current_customer
          customer.step = 31
          customer.code = code
          customer.save(:validate => false)
          customer.abo_history(35, customer.abo_type_id)
        else
          redirect_to promotion_path(:id => params[:id]), :alert => t('session.error_already_customer') and return
        end
      end
    end
    respond_with resource, :location => after_sign_in_path_for(resource)
  end
end