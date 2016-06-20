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
      cookies[:imdb_id] = { value: params[:imdb_id], expires: 15.days.from_now } if params[:imdb_id]
      customer = current_customer
      if customer && customer.abo_active == 1 && @activation && @activation.all_cust?
        customer.tvod_free = customer.tvod_free + @activation.tvod_free if @activation && @activation.tvod_free && @activation.tvod_free > 0
        customer.save(:validate => false)
        customer.abo_history(38, customer.abo_type_id, @activation.to_param)
        @activation.update_attributes(:customers_id => customer.to_param, :created_at => Time.now.localtime)
      else
        customer.step = @promotion.nil? ? 31 : @promotion.goto_step
        customer.tvod_free = @promotion.tvod_free if @promotion && @promotion.tvod_free && @promotion.tvod_free > 0
        customer.abo_active = 1 if @promotion && @promotion.goto_step.to_i == 100
        if @promotion.tvod_only
          customer.auto_stop = 0
          customer.subscription_expiration_date = nil
        end
        customer.code = params[:code]
        customer.save(:validate => false)
        action = 
        if @promotion && @promotion.goto_step.to_i == 100
          @promotion.class.to_s == 'Activation' ? 8 : 6 
        else
          35
        end
        customer.abo_history(action, customer.abo_type_id)
        DiscountUse.create(:discount_code_id => @discount.id, :customer_id => customer.to_param, :discount_use_date => Time.now.localtime) if @discount
        @activation.update_attributes(:customers_id => customer.to_param, :created_at => Time.now.localtime) if @activation
      end
    end
    if params[:code]
      flash[:notice] = t('session.promotion.sucess')
    else
      set_flash_message(:notice, :signed_in) if is_navigational_format?
    end
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
      if @discount
        @promotion = @discount
      elsif @activation
        @promotion = @activation
      else
        @promotion = nil
        redirect_to params[:return_url], :alert => t('session.error_wrong_code') and return
      end
      cookies[:code] = { value: params[:code], expires: 15.days.from_now }
      customer = Customer.where(:email => params[:customer][:email]).first if params[:customer] && params[:customer][:email]
      if @activation || (@discount && customer && customer.discount_reuse?(@discount.month_before_reuse))
        if customer.abo_active == 1 && customer.svod? && ((@activation && !@activation.all_cust? ) || @activation.nil?)
          # VEC IMA SUBSKRIPCIJU!!!
          redirect_to params[:return_url], :alert => t('session.error_already_customer') and return
        end
      elsif @activation || (@discount && customer.tvod_only? && customer.discount_reuse?(@discount.month_before_reuse))
        # STEP 3!!!
        redirect_to step_path(:id => 'step3') and return
      else
        # KOD JE VEC ISKORISTEN!!!
        redirect_to params[:return_url], :alert => t('session.error_discount_reused') and return
      end
    end
  end

end