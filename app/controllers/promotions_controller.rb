class PromotionsController < ApplicationController
  before_filter :get_data
  def show
    Rails.logger.debug { "show promo#{params}" }
  end

  def create
    if params[:id] == 'samsung'
      if !params[:code].nil?
        @code_samsung = params[:code]
        if SamsungCode.available.find_by_code(@code_samsung)
          redirect_to new_customer_registration_path(:samsung => @code_samsung)
        else
          @error = true
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
        @error = true
        render :show
      else
        if current_customer
          customer = current_customer
          customer.step = 31
          customer.code = code
          customer.save
          redirect_to step_path(:id => 'step2')
        else
          redirect_to new_customer_registration_path(:code => code)
        end
      end
    end
  end


  def get_data
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
  end
end