class CarrefourbonusController < ApplicationController

  caches_page :plans

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
        redirect_to new_customer_session_path(:code => params[:abo]) and return
      end
    end
  end
end
