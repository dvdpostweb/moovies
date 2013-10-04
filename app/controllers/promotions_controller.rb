class PromotionsController < ApplicationController
  before_filter :get_data
  def show
    @promotion = Customer.new
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
        redirect_to new_customer_registration_path(:code => code)
      end
    end
  end
  private
  def get_data
    params[:id] = 'smarttv' if params[:id] == 'radio_contact' ||  params[:id] == 'nostalgie'
    @promo = Promotion.find_by_name(params[:id])
    if @promo
      @partial = 'default'
      @body_class = "canvas#{@promo.canva_id}"
      if @promo.canva_id == 1
        if @promo.params['date_limit'] == false
          @promo.params['date_limit'] = 3.days.from_now.strftime('%d/%m/%Y')
        end
      end
    else
      @partial = params[:id]
    end
    @partial += "_#{params[:format]}" if params[:format]
    @body_id = @partial
    @code_samsung = t('promotions.show.samsung.default')
    if params[:id] == 'promotion'
      if params[:code]
        @code_samsung = params[:code]
      else
        @code_samsung = ''
      end
    end
  end
end