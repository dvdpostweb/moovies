class Customers::RegistrationsController < Devise::RegistrationsController
  
  def new
    @hide_footer = true
    @hide_menu = true
    if params[:customer] && params[:customer][:samsung]
      @samsung = params[:customer][:samsung]
    elsif params[:samsung]
      @samsung = params[:samsung]
    end
    if params[:code] || cookies[:code]
      code = params[:code] || cookies[:code]
      @discount = Discount.by_name(code).available.first
      @activation = Activation.by_name(code).available.first
      if @discount
        @promo = @discount
        cookies[:code] = { value: code, expires: 15.days.from_now }
      elsif @activation
        @promo = @activation
        cookies[:code] = { value: code, expires: 15.days.from_now }
      else
        @default_code = Discount.find(Moovies.discount["svod_#{I18n.locale}"]).name
        cookies[:code] = { value: @default_code, expires: 15.days.from_now } 
      end
    end
    super
  end

  def create
    if params[:customer] && params[:customer][:samsung]
      @samsung = params[:customer][:samsung]
    elsif params[:samsung]
      @samsung = params[:samsung]
    end
    if params[:id]
      @user = Customer.find_by_email(params[:customer][:email])
      if @user
        if @user.valid_password?(params[:customer][:password])
          @discount = Discount.by_name(params[:customer][:code]).available.first
          if @discount.nil? || (@discount && @user.discount_reuse?(@discount.month_before_reuse))
            if @user.abo_active == 0
              cookies[:code] = { value: params[:customer][:code], expires: 15.days.from_now }
              @user.step = @discount.nil? ? 31 : @discount.goto_step
              @user.code = params[:customer][:code]
              @user.abo_active = 1 if @discount && @discount.goto_step.to_i == 100
              if @user.tvod_only?
                @user.auto_stop = 0
                @user.subscription_expiration_date = nil
              end
              @user.save(:validate => false)
              @user.abo_history(@discount && @discount.goto_step.to_i == 100 ? 6 : 35, @user.abo_type_id)
              DiscountUse.create(:discount_code_id => @discount.id, :customer_id => @user.to_param, :discount_use_date => Time.now.localtime) if @discount
              if @user.confirmed?
                sign_in @user, :bypass => true
                redirect_to step_path(:id => 'step2') and return
              else
                Devise::Mailer.confirmation_instructions(@user).deliver
                redirect_to step_path(:id => 'confirm') and return
              end
            else
              redirect_to promotion_path(:id => params[:id]), :alert => t('session.error_already_customer') and return
            end
          else
            redirect_to promotion_path(:id => params[:id]), :alert => t('session.error_discount_reused') and return
          end
        end
      end
    end
    build_resource
    @discount = Discount.by_name(params[:customer][:code]).available.first
    if @discount
      cookies[:code] = { value: params[:customer][:code], expires: 15.days.from_now }
      resource.step = @discount.goto_step
      resource.abo_active = 1 if @discount.goto_step.to_i == 100
    end
    
    if resource.save
      resource.abo_history(@discount && @discount.goto_step.to_i == 100 ? 6 : 35, resource.abo_type_id)
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      if params[:id]
         @promo = Promotion.find_by_name(params[:id])
          if @promo
            @partial = 'canvas'
            @body_class = "canvas#{@promo.canva_id}"
            @canvas = @body_class
            @canvas += "_#{params[:format]}" if params[:format] && @promo.params[:choose]
            if !params[:code].nil?
              @code = params[:code]
            elsif params[:customer] && params[:customer][:code]
              @code = params[:customer][:code]
            elsif @promo.params[:code]
              @code = @promo.params[:code]
            else
              @code = ''
            end
          else
            @partial = params[:id]
            @partial += "_#{params[:format]}" if params[:format]
          end

          @body_id = @partial
          @code_samsung = t('promotions.show.samsung.default')
          @checked = params[:marketing] == "1" ? true : false
          if params[:email]
            @email = params[:email]
          elsif params[:customer] && params[:customer][:email]
            @email = params[:customer][:email]
          else
            @email = nil
          end
        render :template => 'promotions/show', :layout => 'promo' 
      else
        respond_with resource
      end
    end    
    
  end
  protected

  def after_inactive_sign_up_path_for(resource)
    step_path(:id => :confirm)
  end

  def after_sign_up_fails_path_for(resource)
    #customer_registration_path
    #return_url
    root_localize_path(:sing_up_failed => 1)
  end

end