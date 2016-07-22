class Customers::RegistrationsController < Devise::RegistrationsController

  #layout :resolve_layout

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
            if @user.abo_active == 0 || (@user.abo_active == 1 && @user.tvod_only?)
              if params[:customer][:abo].present?
                @user.step = 31
                @user.code = params[:customer][:code]
                sub = SubscriptionType.find(params[:customer][:abo])
                @activation.update_attributes(:activation_products_id => params[:customer][:abo], :next_abo_type => params[:customer][:abo])
                @user.tvod_free = @user.tvod_free + sub.tvod_credits
                @user.abo_type_id = params[:customer][:abo]
                @user.next_abo_type_id = params[:customer][:abo]
              else
                cookies[:code] = { value: params[:customer][:code], expires: 15.days.from_now }
                @user.step = @promotion.nil? ? 31 : @promotion.goto_step
                @user.code = params[:customer][:code]
                @user.tvod_free = @promotion.tvod_free if @promotion.tvod_free && @promotion.tvod_free > 0
                @user.abo_active = 1 if @promotion && @promotion.goto_step.to_i == 100
                if @promotion.tvod_only
                  @user.auto_stop = 0
                  @user.subscription_expiration_date = nil
                end
              end
              @user.save(:validate => false)
              action =
              if @promotion && @promotion.goto_step.to_i == 100
                @promotion.class.to_s == 'Activation' ? 8 : 6
              else
                35
              end
              @user.abo_history(action, @user.abo_type_id)
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
                      redirect_to step_path(:id => 'step4') and return
                    end
                  else
                    redirect_to step_path(:id => 'step4') and return
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
      logger.debug params
      if params[:customer][:abo].present?
        resource.step = 31
        resource.code = params[:customer][:code]
        sub = SubscriptionType.find(params[:customer][:abo])
        @promotion.update_attributes(:activation_products_id => params[:customer][:abo], :next_abo_type => params[:customer][:abo])
        resource.tvod_free = resource.tvod_free + sub.tvod_credits
        resource.abo_type_id = params[:customer][:abo]
        resource.next_abo_type_id = params[:customer][:abo]
      else
        resource.tvod_free = @promotion.tvod_free if @promotion.tvod_free && @promotion.tvod_free > 0
        resource.abo_active = 1 if @promotion.goto_step.to_i == 100
      end
    end

    if resource.save
      action =
      if @promotion && @promotion.goto_step.to_i == 100
        @promotion.class.to_s == 'Activation' ? 8 : 6
      else
        35
      end
      resource.abo_history(action, resource.abo_type_id)
      if @promotion && @promotion.goto_step.to_i == 100
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

  private

  def resolve_layout
    case action_name
    when "new"
      "devise_layout"
    else
      "application"
    end
  end

end
