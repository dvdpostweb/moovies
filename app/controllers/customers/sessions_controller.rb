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
      customer.step = @discount.nil? ? 31 : @discount.goto_step
      customer.tvod_free = @discount.tvod_free if @discount && @discount.tvod_free && @discount.tvod_free > 0
      customer.abo_active = 1 if @discount && @discount.goto_step.to_i == 100
      if @discount.tvod_only
        customer.auto_stop = 0
        customer.subscription_expiration_date = nil
      end
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
          cookies[:code] = { value: params[:code], expires: 15.days.from_now }
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