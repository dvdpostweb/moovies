class Customers::SessionsController < Devise::SessionsController
  prepend_before_filter :check_code, only: [:create]
  def new
    @meta_title = t("sessions.new.meta_title", :default => '')
    @meta_description = t("sessions.new.meta_description", :default => '')
    super
  end
  
  def create
    #Rails.logger.debug { "@@@" }
    #@checked = params[:marketing] == "1" ? true : false
    #@meta_title = t("sessions.new.meta_title", :default => '')
    #@meta_description = t("sessions.new.meta_description", :default => '')
    #if params[:id] #promotion
    #  set_flash_message(:notice, :signed_in) if is_navigational_format?
    #
    #  sign_in(resource_name, resource)
    #
    #  code = params[:code]
    #  if code
    #    @discount = Discount.by_name(code).available.first
    #    @activation = Activation.by_name(code).available.first
    #    if @discount.nil? && @activation.nil?
    #      redirect_to params[:return_url], :alert => t('session.error_wrong_code') and return
    #    else
    #      if @discount.nil? || (@discount && current_customer.discount_reuse?(@discount.month_before_reuse))
    #        if current_customer.abo_active == 0
    #          customer = current_customer
    #          customer.step = 31
    #          customer.code = code
    #          customer.save(:validate => false)
    #          customer.abo_history(35, customer.abo_type_id)
    #        else
    #          redirect_to promotion_path(:id => params[:id]), :alert => t('session.error_already_customer') and return
    #        end
    #      else
    #        redirect_to promotion_path(:id => params[:id]), :alert => t('session.error_discount_reused') and return
    #      end
    #    end
    #  end
    #  respond_with resource, :location => after_sign_in_path_for(resource)
    #else #reactive
    #  Rails.logger.debug { "re" }
    #  code = params[:code]
    #  if code
    #    @discount = Discount.by_name(code).available.first
    #    @activation = Activation.by_name(code).available.first
    #    if @discount.nil? && @activation.nil?
    #      redirect_to params[:return_url], :alert => t('session.error_wrong_code') and return
    #    else
    #      customer = Customer.where(:email => params[:customer][:email]).first if params[:customer] && params[:customer][:email]
    #      if @discount.nil? || (@discount && customer && customer.discount_reuse?(@discount.month_before_reuse))
    #        #Rails.logger.debug { "@@@" }
    #        #self.resource = warden.authenticate!(auth_options)
    #        #set_flash_message(:notice, :signed_in) if is_navigational_format?
    #        #sign_in(resource_name, resource)
    #        if current_customer.abo_active == 0
    #          customer = current_customer
    #          customer.step = 31
    #          customer.code = code
    #          customer.save(:validate => false)
    #          customer.abo_history(35, customer.abo_type_id)
    #        else
    #          redirect_to params[:return_url], :alert => t('session.error_already_customer') and return
    #        end
    #      else
    #        redirect_to params[:return_url], :alert => t('session.error_discount_reused') and return
    #      end
    #    end
    #  end
    #  
    #  respond_with resource, :location => after_sign_in_path_for(resource)
    #end
    self.resource = warden.authenticate!(auth_options)
    if params[:code]
      customer = current_customer
      customer.step = 31
      customer.code = params[:code]
      customer.save(:validate => false)
      customer.abo_history(35, customer.abo_type_id)
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
            if customer.abo_active == 1
              redirect_to params[:return_url], :alert => t('session.error_already_customer') and return
            end
          else
            redirect_to params[:return_url], :alert => t('session.error_discount_reused') and return
          end
        end
      end
end