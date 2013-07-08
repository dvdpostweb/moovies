class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale
  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  def set_locale
    I18n.locale = params[:locale] || cookies[:locale] ||extract_locale_from_accept_language_header || I18n.default_locale
    cookies.permanent[:locale] = I18n.locale 
  end
end
