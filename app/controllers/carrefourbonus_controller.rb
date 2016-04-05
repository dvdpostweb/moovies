class CarrefourbonusController < ApplicationController

  def plans

  	@hide_menu = true
    @body_id = 'carrefour'
    @error_abo = false
      @error_code = false
    if request.post?
      
      if params[:abo].blank? || ![7,8,9,10,11].include?(params[:abo].to_i)
        @error_abo = true
      end
      #if params[:carrefour_code].present?
      #  activation = Activation.by_name(params[:carrefour_code]).available.first
      #  unless activation
      #    @error_code = true
      #  end
      #else
      #  @error_code = true
      #end
      if @error_code == false && @error_abo == false
        redirect_to new_customer_registration_path( :code => params[:carrefour_code], :abo => params[:abo]) and return 
      end
    end

  end

end
