class Customers::SessionsController < Devise::SessionsController

  layout :resolve_layout

  def new
    gon.code = params[:code]
    gon.moovie_id = params[:moovie_id]
    gon.activation = params[:activation]
    gon.samsung = params[:samsung]
  end

  private

  def resolve_layout
    if request.user_agent =~ /Mobile|webOS/
      "mobile/mobile"
    else
      "devise_layout"
    end
  end

end
