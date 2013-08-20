module ApplicationHelper

  def streaming_access?
    !current_customer || session[:country_id] == 22 || session[:country_id] == 131 || session[:country_id] == 0 || session[:country_id] == 161 || current_customer.super_user?
  end

  def sort_review_for_select
    options = []
    codes_hash = Review.sort
    codes_hash.each {|key, code| options.push [t(".#{key}"), key]}
    options
  end

  def sort_review2_for_select
    options = []
    codes_hash = Review.sort2
    codes_hash.each {|key, code| options.push [t(".#{key}"), key]}
    options
  end

  def switch_locale_link(options=nil)
    content = ''
    I18n.available_locales.each do |locale|
      new_params = params.merge(:locale => locale)
      new_params.delete(:kind)
      content += content_tag(:li, link_to(locale.to_s.upcase, new_params, {:class => I18n.locale.to_s == locale.to_s ? 'active' : 'nothing'}))
    end
    content.html_safe
  end

  def streaming_btn_title(type, text)
    if(type == :replay)
      text == :short ? t('.replay_short') : t('.replay')
    else
      text == :short ? t('.buy_short') : t('.buy')
    end
  end

  def format_text(browser)
    #to do
    #if browser.windows?
    #  "pc"
    #elsif browser.mac?
    #  "mac"
    #elsif browser.iphone?
    #  "iphone"
    #elsif browser.ipad?
    #  "ipad"
    #elsif browser.ipod?
    #  "ipod"
    #elsif browser.tablet?
    #  "tablet"
    #elsif browser.mobile?
    #  "mobile"
    #else
    #  "other"
    #end
    nil
  end

  def get_current_filter(options = {})
    if cookies[:filter_id]
      current_filter = SearchFilter.get_filter(cookies[:filter_id])
      unless current_filter.to_param
        current_customer.update_attributes(:filter_id => nil) if current_customer
        cookies.delete :filter_id
      end
      if !options.empty?
        current_filter.update_with_defaults(options)
      end
    else
      if current_customer && current_customer.filter_id
        cookies[:filter_id] = { :value => current_customer.filter_id, :expires => 1.year.from_now }
        current_filter = SearchFilter.get_filter(current_customer.filter_id)
        unless current_filter.to_param
          current_customer.update_attributes(:filter_id => nil) if current_customer
          cookies.delete :filter_id
        end
        if !options.empty?
          current_filter.update_with_defaults(options)
        end
      else
        current_filter = SearchFilter.get_filter(nil)
        current_filter.update_with_defaults(options)
        cookies[:filter_id] = { :value => current_filter.to_param, :expires => 1.year.from_now }
        current_customer.update_attributes(:filter_id => current_filter.to_param) if current_customer
      end
    end
    current_filter
  end
  
  def streaming_access?
    true
  end
  
  def twitter_url
    'http://twitter.com'
  end

  def facebook_url(locale)
    'http://facebook.com'
  end

  def image_url(source)
    URI.join(root_url, image_path(source))
  end

  def get_geo_name(id)
    Moovies.geo_country_name[id]
  end

  
end
