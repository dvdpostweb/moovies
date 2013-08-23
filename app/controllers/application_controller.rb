class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  before_filter :set_locale
  before_filter :get_wishlist_source
  before_filter :init
  before_filter :redirect_after_registration
  
  layout :layout_by_resource
  
  def handle_unverified_request
    raise ActionController::InvalidAuthenticityToken
  end

  def default_url_options
    if params[:kind] == :normal
      { :locale => I18n.locale }
    else
      { :locale => I18n.locale, :kind => params[:kind] }
    end
  end


  def redirect_after_registration(path = nil)
    if current_customer && current_customer.step != 100 && params[:controller] != 'devise/sessions' && params[:controller] != 'payment_methods' && !(params[:controller] == 'info' && params[:page_name] == 'conditions')
      if current_customer.step.to_i == 31
        if (params['controller'] == 'steps' && params[:id] == 'step2') || (params[:controller] == 'customers' && params[:action] == 'update')
        else
          redirect_to step_path(:id => 'step2')
        end
      elsif current_customer.step.to_i == 33
        if (params['controller'] == 'steps' && params[:id] == 'step3') || (params[:controller] == 'ogones')
        else
          redirect_to step_path(:id => 'step3')
        end
      elsif current_customer.step.to_i == 90
        redirect_to step_path(:id => 'old')
      elsif path
        redirect_to path
      end
    end
  end

  protected

  def layout_by_resource
    if devise_controller? and params[:controller] != 'customers/registrations'
      "devise_layout"
    elsif params[:controller] == 'promotions' and params[:id] != 'smarttv'
      'promo'
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
    @browser = Browser.new(:ua => request.user_agent, :accept_language => "en-us")
    @kid_visible = false
    cookies.permanent[:adult_hide] = params[:all] if params[:all]
    @discount_top = Discount.find(Moovies.discount["hp_top_#{I18n.locale}"])
    params[:kind] = params[:kind] ? params[:kind].to_sym : :normal
    if params[:locale].nil?
      params[:locale] = I18n.locale
    end

    if params[:debug_country_id]
      session[:country_id] = params[:debug_country_id].to_i
    else
      if session[:country_id].nil? || session[:country_id] == 0
        ip_regex = /^([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])$/
        my_ip = request.env["HTTP_X_FORWARDED_FOR"] if !ip_regex.match(request.env["HTTP_X_FORWARDED_FOR"]).nil? && ! /^192(.*)/.match(request.env["HTTP_X_FORWARDED_FOR"]) && ! /^172(.*)/.match(request.env["HTTP_X_FORWARDED_FOR"]) && ! /^10(.*)/.match(request.env["HTTP_X_FORWARDED_FOR"])
        my_ip = request.remote_ip if my_ip.nil?
        c = GeoIP.new('GeoIP.dat').country(my_ip)
        if c.country_code == 0 && Rails.env == "production" && ! /^192(.*)/.match(my_ip) && ! /^172(.*)/.match(my_ip) && ! /^10(.*)/.match(my_ip) && ! /^127(.*)/.match(my_ip)
          notify_airbrake("country code is empty ip : #{my_ip}") 
        end
        session[:country_id] = c.country_code
      end
    end
  end

  private

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first if request.env['HTTP_ACCEPT_LANGUAGE']
  end

  def notify_airbrake(message)
    begin
      Airbrake.notify(:error_message => "GeoIP error : #{message}", :backtrace => $@, :environment_name => ENV['RAILS_ENV'])
    rescue => e
      logger.error("GeoIP error: #{message}")
      logger.error(e.backtrace)
    end
  end
  
end
