class Customers::RegistrationsController < Devise::RegistrationsController

  layout "responsive"

  def new
    gon.code = params[:code]
    gon.moovie_id = params[:moovie_id]
    gon.activation = params[:activation]
  end

end
