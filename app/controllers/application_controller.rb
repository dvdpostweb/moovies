class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  before_filter :set_locale
  before_filter :get_wishlist_source
  before_filter :init
  before_filter :redirect_after_registration
  
  layout :layout_by_resource

  def default_url_options
    if params[:kind] == :normal
      { :locale => I18n.locale }
    else
      { :locale => I18n.locale, :kind => params[:kind] }
    end
  end


  def redirect_after_registration(path = nil)
    if current_customer && current_customer.step != 100 &&  params[:controller] != 'devise/sessions'
      if current_customer.step.to_i == 31
        if (params['controller'] == 'steps' && params[:page_name] == 'step2') || (params[:controller] == 'customers' && params[:action] == 'update')
        else
          redirect_to step_path(:page_name => 'step2')
        end
      elsif current_customer.step.to_i == 33
        if (params['controller'] == 'steps' && params[:page_name] == 'step3') || (params[:controller] == 'ogones' && params[:action] == 'show')
        else
          redirect_to step_path(:page_name => 'step3')
        end
      elsif current_customer.step.to_i == 90
        #to do 
        #if (params['controller'] == 'steps' && params[:page_name].to_i == 5) || (params['controller'] == 'steps' && params[:id].to_i == 1 && params[:action] == 'update')
        #else
        #  redirect_to step_path(:id => 5)
        #end
      elsif path
        redirect_to path
      end
    end
  end

  protected

  def layout_by_resource
    if devise_controller? and params[:controller] != 'customers/registrations'
      "devise_layout"
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

  def init
    @browser = 'empty'
    @kid_visible = false
    params[:kind] = params[:kind] ? params[:kind].to_sym : :normal
    if params[:locale].nil?
      params[:locale] = I18n.locale
    end
  end

  private

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
  
end
