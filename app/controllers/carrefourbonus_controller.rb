class CarrefourbonusController < ApplicationController
  def plans
  	@hide_menu = true
    @body_id = 'carrefour'
    @error_abo = false
      @error_code = false
    if request.post?
      if params[:abo].blank?
        @error_abo = true
      end
      if @error_code == false && @error_abo == false
        redirect_to customers_reactive_path( :code => params[:abo]) and return 
      end
    end
  end
end
