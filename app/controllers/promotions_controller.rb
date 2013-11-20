class PromotionsController < ApplicationController
  before_filter :get_data
  def show
  end

  def create
    if params[:id] == 'samsung'
      if !params[:code].nil?
        @code_samsung = params[:code]
        if SamsungCode.available.find_by_code(@code_samsung)
          redirect_to new_customer_registration_path(:samsung => @code_samsung)
        else
          @error = true
          flash.discard
          @checked = params[:marketing] == "1" ? true : false
          render :show
        end
      else
        render :show
      end
    else  
      code = params[:code]
      @discount = Discount.by_name(code).available.first
      @activation = Activation.by_name(code).available.first
      if @discount.nil? && @activation.nil?
        flash[:alert] = 'error de code'
        flash.discard
        render :show
      else
        if params[:email]
          @user = Customer.find_by_email(params[:email])
          if !@user.confirmed?
            Devise::Mailer.confirmation_instructions(@user).deliver
          end
        end
        
        if current_customer
          if current_customer.abo_active == 0
            customer = current_customer
            customer.step = 31
            customer.code = code
            customer.save(:validate => false)
            customer.abo_history(35, customer.abo_type_id)
            redirect_to step_path(:id => 'step2')
          else
            flash[:alert] = 'not used'
            render :show
          end
        else
          redirect_to new_customer_registration_path(:code => code)
        end
      end
    end
  end


  def get_data
    params[:id] = 'smarttv' if params[:id] == 'radio_contact' ||  params[:id] == 'nostalgie'
    @checked = true if params[:checked]
    @promo = Promotion.find_by_name(params[:id])
    if @promo
      @partial = 'canvas'
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
end