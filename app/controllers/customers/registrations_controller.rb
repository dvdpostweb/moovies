class Customers::RegistrationsController < Devise::RegistrationsController

  layout :resolve_layout

  def new
    gon.code = params[:code]
    gon.moovie_id = params[:moovie_id]
    gon.activation = params[:activation]
  end

  private

  def resolve_layout
    case action_name
      when "new"
        "devise_layout"
      else
        "application"
    end
  end

end
