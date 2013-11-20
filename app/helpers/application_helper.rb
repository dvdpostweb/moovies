module ApplicationHelper

  def send_message(mail_id, options, locale, customer_default = nil)
    customer = customer_default ? customer_default : current_customer
    mail_object = Email.by_language(locale).find(mail_id)
    recipient = customer
    if 1==1 || mail_object.force_copy
      mail_history= MailHistory.create(:date => Time.now().to_s(:db), :customers_id => customer.to_param, :mail_messages_id => mail_id, :language_id => Moovies.customer_languages[locale], :customers_email_address=> customer.email)
      options["\\$\\$\\$mail_messages_sent_history_id\\$\\$\\$"] = mail_history.to_param
    else
      options["\\$\\$\\$mail_messages_sent_history_id\\$\\$\\$"] = 0
    end
      list = ""
      options.each {|k, v|  list << "#{k.to_s.tr("\\","")}:::#{v};;;"}
      #to do 
      if 1 == 1 || mail_object.force_copy
        email_data_replace(mail_object.subject, options)
        subject = email_data_replace(mail_object.subject, options)
        message = email_data_replace(mail_object.body, options)
        mail_history.update_attributes(:lstvariable => list)
        Emailer.welcome_email(recipient, subject, message, Rails.env == 'development' ? true : false).deliver
      end
      @ticket = Ticket.new(:customer_id => customer.to_param, :category_ticket_id => mail_object.category_id)
      @ticket.save
      if mail_history
        @message = MessageTicket.new(:ticket => @ticket, :mail_id => mail_id, :data => list, :user_id => 55, :mail_history_id => mail_history.to_param)
      else
        @message = MessageTicket.new(:ticket => @ticket, :mail_id => mail_id, :data => list, :user_id => 55)
      end
      @message.save
  end

  def email_data_replace(text,options)
    options.each {|key, value| 
      r = Regexp.new(key, true)
      text = text.gsub(r, value.to_s)
    }
    text
  end

  def streaming_access?
    session[:country_id] == 22 || session[:country_id] == 131 || session[:country_id] == 0 || session[:country_id] == 161 || (current_customer && current_customer.super_user?)
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
      new_params = params.merge(:locale => locale.to_s)
      new_params.delete(:kind)
      content += content_tag(:li, link_to(locale.to_s.upcase, url_for(new_params), {:class => I18n.locale.to_s == locale.to_s ? 'active' : 'nothing'}))
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
    if browser.windows?
      "pc"
    elsif browser.mac?
      "mac"
    elsif browser.iphone?
      "iphone"
    elsif browser.ipad?
      "ipad"
    elsif browser.ipod?
      "ipod"
    elsif browser.tablet?
      "tablet"
    elsif browser.mobile?
      "mobile"
    else
      "other"
    end
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
  
  def image_url(source)
    URI.join(root_url, image_path(source))
  end

  def get_geo_name(id)
    Moovies.geo_country_name[id]
  end

  def get_code(code)
    if params[:kind] == :normal && cookies[:code]
      cookies[:code]
    else
      code
    end
  end

  def resource_name
     :customer
  end

  def resource
     @resource ||= Customer.new
  end

  def devise_mapping
     @devise_mapping ||= Devise.mappings[:customer]
  end

end
