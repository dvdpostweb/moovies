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
    
    @partial = params[:id]
    @partial += "_#{params[:format]}" if params[:format]
    @body_id = @partial
    @code_samsung = t('promotions.show.samsung.default')
    @code_samsung = '' if params[:id] == 'promotion'
  end
end