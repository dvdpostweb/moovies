class Customers::SessionsController < Devise::SessionsController
  prepend_before_filter :check_code, only: [:create]
  def new
    @meta_title = t("sessions.new.meta_title", :default => '')
    @meta_description = t("sessions.new.meta_description", :default => '')
    super
  end
  
  def create
    self.resource = warden.authenticate!(auth_options)
    if params[:code]
      customer = current_customer
      customer.step = @discount.goto_step
      customer.customer_abo = 1 if @discount && @discount.goto_step.to_i == 100
      customer.code = params[:code]
      customer.save(:validate => false)
      customer.abo_history(@discount && @discount.goto_step.to_i == 100 ? 6 : 35, customer.abo_type_id)
      DiscountUse.create(:discount_code_id => @discount.id, :customer_id => customer.to_param, :discount_use_date => Time.now.localtime) if @discount
    end
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    respond_with resource, :location => after_sign_in_path_for(resource)
    
  end
  private
    def create?
      params[:action] == 'create'
    end

    def check_code
        if params[:code]
          @discount = Discount.by_name(params[:code]).available.first
          @activation = Activation.by_name(params[:code]).available.first
          if @discount.nil? && @activation.nil?
            redirect_to params[:return_url], :alert => t('session.error_wrong_code') and return
          end
          customer = Customer.where(:email => params[:customer][:email]).first if params[:customer] && params[:customer][:email]
          if @discount.nil? || (@discount && customer && customer.discount_reuse?(@discount.month_before_reuse))
            if customer && customer.abo_active == 1
              redirect_to params[:return_url], :alert => t('session.error_already_customer') and return
            end
          else
            redirect_to params[:return_url], :alert => t('session.error_discount_reused') and return
          end
        end
      end
end