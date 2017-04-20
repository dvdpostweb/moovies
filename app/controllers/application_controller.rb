class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  before_filter :set_locale, :unless => :flag?
  before_filter :init, :unless => :flag?
  before_filter :set_gon
  before_filter :redirect_after_registration, :unless => :flag?
  before_filter :get_wishlist_source, :unless => :flag?
  before_filter :validation_adult, :unless => :flag?
  before_filter :authenticate, :if => :staging?

  #before_filter :set_cache_buster

  layout :layout_by_resource

  def set_gon
    gon.current_customer = current_customer
    gon.locale = I18n.locale
    gon.root_localize_path = root_localize_path
    gon.request_host = request.host if Rails.env.development?
    gon.params = params if Rails.env.development?
    gon.modal_close_button_text = t('bootstrap.modal.close')
  end

  #def handle_unverified_request
  #  raise ActionController::InvalidAuthenticityToken
  #end

  def default_url_options
    if params[:kind] == :normal
      { :locale => I18n.locale }
    else
      { :locale => I18n.locale, :kind => params[:kind] }
    end
  end

  def redirect_after_registration(path = nil)
    if current_customer && current_customer.step != 100 && params[:controller] != 'devise/sessions' && params[:controller] != 'customers/sessions' && params[:controller] != 'payment_methods' && !(params[:controller] == 'info' && params[:page_name] == t('routes.infos.params.conditions')) && params[:controller] != 'promotions' && params[:action] != 'back_to_tvod'
      if current_customer.step.to_i == 31
        if (params['controller'] == 'steps' && params[:id] == 'step2') || (params[:controller] == 'customers' && params[:action] == 'update')
        else
          redirect_to step_path(:id => 'step2')
        end
      elsif current_customer.step.to_i == 32
        if (params['controller'] == 'steps' && params[:id] == 'invoice') || (params[:controller] == 'images' && params[:action] == 'create') || (params[:controller] == 'images' && params[:action] == 'create')
        else
          redirect_to step_path(:id => 'invoice')
        end
      elsif current_customer.step.to_i == 33
        if (params['controller'] == 'steps' && params[:id] == 'step3') || (params[:controller] == 'ogones') || (params[:controller] == 'api/v1/paypal') || (params[:controller] == 'api/v1/virement') || (params[:controller] == 'api/v1/subscriptions') || (params[:controller] == 'api/v1/ogone_tokenization')
        else
          redirect_to step_path(:id => 'step3')
        end
      elsif current_customer.step.to_i == 90
        if (params['controller'] == 'info' && params[:page_name] == t('routes.infos.params.alacarte')) || (params[:controller] == 'customers' && params[:action] == 'update')
        else
        redirect_to info_path(:page_name => t('routes.infos.params.alacarte'))
        end
      elsif path
        redirect_to path
      end
    end
  end

  protected

  def products?
    params[:controller] == 'products'
  end

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def layout_by_resource
    #if params[:controller] == 'promotions'
    #  'promo'
    if params[:controller] == 'errors'
      'errors'
    else
      "application"
    end
  end

  def set_locale
    if params[:controller] != 'ogones'
      I18n.locale = params[:locale] || cookies[:locale] || extract_locale_from_accept_language_header || I18n.default_locale
      if I18n.available_locales.include?(I18n.locale)
        cookies.permanent[:locale] = I18n.locale
      else
        I18n.locale = :fr
      end
      current_customer.update_locale(locale) if customer_signed_in?
    end
  end

  def get_wishlist_source
    @wishlist_source = {}
    wl_source = WishlistSource.find(:all)
    wl_source.each do |item|
      @wishlist_source[item.name.downcase.to_sym] = item.to_param
    end
  end

  def init
    cookies[:code] = { value: params[:code], expires: 15.days.from_now } if params[:code]
    if cookies[:code].present?
      code = cookies[:code]
      @discount = Discount.by_name(code).available.first
      @activation = Activation.by_name(code).available.first
      if @discount
          @promotion = @discount
      elsif @activation
        @promotion = @activation
      end
    end
    @browser = Browser.new(:ua => request.user_agent, :accept_language => "en-us")
    @kid_visible = false
    cookies.permanent[:adult_hide] = params[:all] if params[:all]
    params[:kind] = params[:kind] ? params[:kind].to_sym : :normal
    @discount_top = Discount.find(Moovies.discount["hp_top_#{I18n.locale}_#{params[:kind]}"])
    if params[:locale].nil?
      params[:locale] = I18n.locale
    end
    if params[:debug_country_id]
      session[:country_id] = params[:debug_country_id].to_i
    else
      my_ip = request.remote_ip
      if session[:country_id].nil? || session[:country_id] == 20 || session[:my_ip] != my_ip
        ip_regex = /^([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])$/
        my_forwarded_ip = request.env["HTTP_X_FORWARDED_FOR"] if !ip_regex.match(request.env["HTTP_X_FORWARDED_FOR"]).nil? && ! /^192(.*)/.match(request.env["HTTP_X_FORWARDED_FOR"]) && ! /^172(.*)/.match(request.env["HTTP_X_FORWARDED_FOR"]) && ! /^10\.(.*)/.match(request.env["HTTP_X_FORWARDED_FOR"])
        cf = GeoIP.new('GeoIP.dat').country(my_forwarded_ip) if my_forwarded_ip
        c = GeoIP.new('GeoIP.dat').country(my_ip)
        session[:my_ip] = my_ip
        if c.country_code == 0 && Rails.env == "production" && ! /^192(.*)/.match(my_ip) && ! /^172(.*)/.match(my_ip) && ! /^10\.(.*)/.match(my_ip) && ! /^127(.*)/.match(my_ip)
          notify_hoptoad("country code is empty ip : #{my_ip}")
        end
        if cf && (cf.country_code == 22 || cf.country_code == 161 || cf.country_code == 131)
          session[:country_id] = cf.country_code
        else
          session[:country_id] = c.country_code
        end
      end
    end
  end

  private

  def check_request?
    request.ssl? ? @dynamic_link = 'https://yandex.st/swfobject/2.2/swfobject.min.js' : @dynamic_link = 'http://yandex.st/swfobject/2.2/swfobject.min.js'
  end

  def notify_hoptoad(message)
    begin
      Airbrake.notify(:error_message => "GeoIP error : #{message}", :backtrace => $@, :environment_name => ENV['RAILS_ENV'])
    rescue => e
      logger.error("GeoIP error: #{message}")
      logger.error(e.backtrace)
    end
  end


  def after_sign_out_path_for(resource_or_scope)
    #cookies.delete :customer_identificator
    root_localize_path
  end

  def staging?
    Rails.env == 'staging'
  end

  def flag?
    params[:action] == 'flag'
  end

  def authenticate
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == 'plush' && password == 'meninblack'
    end
  end

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

  def validation_adult
    if params[:kind] == :adult && !session[:adult] && params['action'] != 'validation' && params['action'] != 'authenticate'
      prefix = "http://"
      session['current_uri'] = prefix + request.host_with_port + request.fullpath
      redirect_to validation_path
    end
  end

end
