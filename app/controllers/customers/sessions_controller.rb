class Customers::SessionsController < Devise::SessionsController

  caches_page :new

  def new
    gon.code = params[:code]
    gon.moovie_id = params[:moovie_id]
    gon.activation = params[:activation]
    gon.samsung = params[:samsung]
  end

end
