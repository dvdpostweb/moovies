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
        cookies[:code] = { value: code, expires: 15.days.from_now }
      elsif @activation
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
    @user = Customer.find_by_email(params[:customer][:email])
    if @user and @user.confirmed? and @user.valid_password?(params[:customer][:password])
      sign_in @user, :bypass => true
      redirect_to root_localize_path and return
    end
    build_resource

    if resource.save
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
         params[:id] = 'smarttv' if params[:id] == 'radio_contact' ||  params[:id] == 'nostalgie'
          @promo = Promotion.find_by_name(params[:id])
          if @promo
            @partial = 'default'
            @body_class = "canvas#{@promo.canva_id}"
            @canvas = @body_class
            @canvas += "_#{params[:format]}" if params[:format] && @promo.params[:choose]
            if !params[:code].nil?
              @code = params[:code]
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