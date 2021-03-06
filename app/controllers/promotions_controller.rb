class PromotionsController < ApplicationController
  before_filter :get_data
  layout :chose_layout
  def show
    gon.customer_session_path = customer_session_path
    if @promo && @promo.canva_id == 3
      @checked = true
      @checked_partners = false
    elsif @promo && @promo.canva_id == 8
      @checked = true
      @checked_partners = true
      streaming_code = StreamingCode.where('name like ?', "#{@promo.params[:code]}%").email.available.order('rand()').limit(1)
      #@internal_code = streaming_code.first.name
      @meta_image = @promo.params[:image]
    end
    @meta_title = t("promotions.title_#{@promo.id}", :default => '') if @promo

  end

  def create
    @checked = params[:marketing] == "1" ? true : false
    @checked_partners = params[:marketing_partners] == "1" ? true : false
    if params[:id] == 'samsung'
      if !params[:code].nil?
        @code_samsung = params[:code]
        if SamsungCode.available.find_by_code(@code_samsung)
          redirect_to new_customer_session_path(:samsung => @code_samsung)
        else
          @error = true
          flash.discard
          render :show
        end
      else
        render :show
      end
    elsif @promo && (@promo.canva_id == 3 || @promo.canva_id == 8)
      @error = ''
      streaming_code = StreamingCode.where('name like ?', "#{@promo.params[:code]}%").email.available.order('rand()').limit(1)
      @internal_code = streaming_code.first.name

      if !/\A[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+\.[A-Za-z]+\z/.match(params[:email])
        @error += "#{t('promotions.create.wrong_email')}<br />"
      end
      if !@streaming_code = StreamingCode.by_name(params[:streaming_code]).email.available.first
        @error += t('promotions.create.wrong_code')
      end
      if @error == ''
        if !@streaming_code.mail_id.nil?
          options = {
            "\\$\\$\\$link\\$\\$\\$" => streaming_product_url(:id => 1645155, :email => params[:email], :streaming_code => params[:streaming_code])
          }
          view_context.send_message_public(@streaming_code.mail_id, options, I18n.locale, params[:email])
        end
        StreamingCode.by_name(params[:streaming_code]).first.update_attribute(:email, params[:email])
        marketing = params[:marketing] || 0
        marketing_partners = params[:marketing_partners] || 0
        if prospect = Prospect.where(:email => params[:email]).first
          prospect.update_attributes(:newsletters => marketing, :newsletters_partners => marketing_partners, :locale_id => Moovies.customer_languages[I18n.locale])
        else
          Prospect.create(:email => params[:email], :newsletters => marketing, :newsletters_partners => marketing_partners, :locale_id => Moovies.customer_languages[I18n.locale])
        end

      else
        render :show
      end
    elsif params[:id] == "orange"
      if params[:code].present?
        activation = Activation.find_by_activation_code(params[:code])
        code = Customer.find_by_activation_discount_code_id(activation.id)
        if activation.present?
          if customer_signed_in?
            if code.present? || activation.activation_code_validto_date < Date.today
              flash[:alert] = t('session.error_alreadyused_code')
            else
              customer = current_customer
              customer.tvod_free = current_customer.tvod_free + activation.tvod_free if customer.tvod_only?
              customer.code = params[:code]
              customer.customers_abo = 1
              if customer.save!
                current_customer.abo_history(38, current_customer.abo_type_id, activation.to_param)
                activation.update_attributes(:customers_id => current_customer.to_param, :created_at => Time.now.localtime)
                redirect_to root_localize_path, notice: t('session.promotion.sucess') and return
              end
            end
          else
            if params[:code].present?
              redirect_to new_customer_session_path(:code => params[:code])
            end
          end
        else
          flash[:alert] = t('session.error_code_not_present')
        end
      else
        flash[:alert] = t('session.error_code_missing')
      end
    else
      code = params[:code]
      @discount = Discount.by_name(code).available.first
      @activation = Activation.by_name(code).available.first
      if @discount
          @promotion = @discount
      elsif @activation
        @promotion = @activation
      end
      if @promotion
        if params[:email]
          @user = Customer.find_by_email(params[:email])
          if !@user.confirmed?
            Devise::Mailer.confirmation_instructions(@user).deliver
          end
        end
        if current_customer
          if @activation || (@discount && current_customer.discount_reuse?(@discount.month_before_reuse))
            if current_customer.abo_active == 1 && @activation && (@activation.all_cust? || current_customer.tvod_only?)
              current_customer.tvod_free = current_customer.tvod_free + @activation.tvod_free if @activation && @activation.tvod_free && @activation.tvod_free > 0
              current_customer.save(:validate => false)
              current_customer.abo_history(38, current_customer.abo_type_id, @activation.to_param)
              @activation.update_attributes(:customers_id => current_customer.to_param, :created_at => Time.now.localtime)
              redirect_to root_localize_path, notice: t('session.promotion.sucess') and return
            elsif current_customer.abo_active == 0 || (current_customer.abo_active == 1 && current_customer.tvod_only?)
              customer = current_customer
              customer.step = 33 #@promotion.nil? ? 31 : @promotion.goto_step
              customer.tvod_free = @promotion.tvod_free if @promotion && @promotion.tvod_free && @promotion.tvod_free > 0
              customer.code = code
              customer.abo_active = 1 if @promotion && @promotion.goto_step.to_i == 100
              if @promotion.tvod_only
                customer.auto_stop = 0
                customer.subscription_expiration_date = nil
              end
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
              if customer.step == 100
                if params[:imdb_id]
                  product = Product.where(:imdb_id => params[:imdb_id]).first
                  if product
                    redirect_to product_path(:id => product.to_param) and return
                  else
                    redirect_to step_path(:id => 'step4') and return
                  end
                else
                  redirect_to step_path(:id => 'step4') and return
                end
              else
                redirect_to step_path(:id => 'step3')
              end
            else
              flash[:alert] = t('session.error_already_customer')
              flash.discard
              render :show
            end
          else
            flash[:alert] = t('session.error_discount_reused')
            flash.discard
            render :show
          end
        else
          redirect_to new_customer_session_path(:code => code)
        end
      else
        flash[:alert] = t('session.error_wrong_code')
        flash.discard
        render :show
      end
    end
  end


  def get_data
    params[:id] = 'smarttv' if params[:id] == 'radio_contact' ||  params[:id] == 'nostalgie'
    @checked = true if params[:checked]
    id = params[:id].gsub(/[^0-9a-zA-Z-]/,'')

    @promo = Promotion.find_by_name(id)
    if @promo
      params[:id] == 'orange' ? @partial = 'orange' : @partial = 'canvas'
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
    if params[:email]
      @email = params[:email]
    elsif params[:customer] && params[:customer][:email]
      @email = params[:customer][:email]
    else
      @email = nil
    end
    if params[:email] && !params[:email].blank?
      @prospect = Customer.find_by_email(params[:email])
    else
      @prospect = nil
    end
  end

  private

  def chose_layout
    case params[:id]
      when 'orange' then 'orangepromo'
      when 'mobistar' then 'mobistarpromo'
      when 'playstation-offer' then 'playstationpromo'
      when 'playstation' then 'playstationpromo'
      when 'BNPPF' then 'bnppfpromo'
    else
    'promo'
    end 
    
  end

end
