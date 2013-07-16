class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  before_filter :set_locale
  before_filter :get_wishlist_source
  before_filter :set_browser
  
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
    I18n.locale = params[:locale] || cookies[:locale] || extract_locale_from_accept_language_header || I18n.default_locale
    if I18n.available_locales.include?(I18n.locale)
      cookies.permanent[:locale] = I18n.locale 
    else
      I18n.locale = :fr
    end
    current_customer.update_locale(locale) if current_customer
  end

  def get_wishlist_source
    @wishlist_source = {}
    wl_source = WishlistSource.find(:all)
    wl_source.each do |item|
      @wishlist_source[item.name.downcase.to_sym] = item.to_param
    end
  end

  def set_browser
    @browser = 'empty'
  end

  private

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
  
end
