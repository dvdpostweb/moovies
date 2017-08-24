class Customers::RegistrationsController < Devise::RegistrationsController

  def new
    gon.code = params[:code]
    gon.moovie_id = params[:moovie_id]
    gon.activation = params[:activation]
    redirect_to(info_path(:page_name => t('routes.infos.params.alacarte'), :subscription_action_registration => "select_your_package")) unless params[:code].present? || params[:moovie_id].present?
  end

  protected

  def after_update_path_for(resource)
    request.referrer
  end

end
