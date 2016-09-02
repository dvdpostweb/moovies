class Customers::SessionsController < Devise::SessionsController


  def new
    gon.code = params[:code]
    gon.moovie_id = params[:moovie_id]
    gon.activation = params[:activation]
    gon.samsung = params[:samsung]
  end

end
