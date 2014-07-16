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
    @discount = Discount.by_name(params[:customer][:code]).available.first
    @activation = Activation.by_name(params[:customer][:code]).available.first
    if @discount
      @promotion = @discount
    elsif @activation
      @promotion = @activation
    else
      @promotion = nil
    end
    if params[:id]
      cookies[:imdb_id] = { value: params[:imdb_id], expires: 15.days.from_now } if params[:imdb_id]
      @user = Customer.find_by_email(params[:customer][:email])
      if @user
        if @user.valid_password?(params[:customer][:password])
          if @activation || (@discount && @user.discount_reuse?(@discount.month_before_reuse))
            if @user.abo_active == 0
              cookies[:code] = { value: params[:customer][:code], expires: 15.days.from_now }
              @user.step = @promotion.nil? ? 31 : @promotion.goto_step
              @user.code = params[:customer][:code]
<<<<<<< HEAD
              @user.tvod_free = @promotion.tvod_free if @promotion.tvod_free && @promotion.tvod_free > 0
              @user.abo_active = 1 if @promotion && @promotion.goto_step.to_i == 100
              if @promotion.tvod_only
=======
              @user.tvod_free = @discount.tvod_free if @discount.tvod_free && @discount.tvod_free > 0
              @user.abo_active = 1 if @discount && @discount.goto_step.to_i == 100
              if @discount.tvod_only
>>>>>>> e7d339fb2cdc15a4b1c1f2f96c73f246d2fdecf0
                @user.auto_stop = 0
                @user.subscription_expiration_date = nil
              end
              @user.save(:validate => false)
              @user.abo_history(@promotion && @promotion.goto_step.to_i == 100 ? 6 : 35, @user.abo_type_id)
              DiscountUse.create(:discount_code_id => @discount.id, :customer_id => @user.to_param, :discount_use_date => Time.now.localtime) if @discount
              @activation.update_attributes(:customers_id => @user.id, :created_at => Time.now.localtime) if @activation
              if @user.confirmed?
                sign_in @user, :bypass => true
                if @user.step == 100
                  if cookies[:imdb_id]
                    product = Product.where(:imdb_id => cookies[:imdb_id]).first
                    cookies.delete :imdb_id
                    if product
                      redirect_to product_path(:id => product.to_param) and return
                    else
                      redirect_to root_localize_path and return
                    end
                  else
                    redirect_to root_localize_path and return
                  end
                else
                  redirect_to step_path(:id => 'step2') and return
                end
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
    if @promotion
      cookies[:code] = { value: params[:customer][:code], expires: 15.days.from_now }
      resource.step = @promotion.goto_step
      resource.tvod_free = @promotion.tvod_free if @promotion.tvod_free && @promotion.tvod_free > 0
      resource.abo_active = 1 if @promotion.goto_step.to_i == 100
    end
    
    if resource.save
      resource.abo_history(@promotion && @promotion.goto_step.to_i == 100 ? 6 : 35, resource.abo_type_id)
      if @promotion.goto_step.to_i == 100
        DiscountUse.create(:discount_code_id => @discount.id, :customer_id => resource.to_param, :discount_use_date => Time.now.localtime) if @discount
        @activation.update_attributes(:customers_id => resource.id, :created_at => Time.now.localtime) if @activation
      end

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