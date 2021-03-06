module ApplicationHelper

  def set_prefix_orange(r)
    case r
      when "plushlu.dev" then
        "+352"
      when "plushbe.dev" then
        "+32"
      when "staging.plush.lu" then
        "+352"
      when "staging.plush.be" then
        "+32"
      when "www.plush.lu" then
        "+352"
      when "www.plush.be" then
        "+32"
    end
  end

  def configure_content_div_html_class(params)
    if params[:controller].present? && params[:controller] == "products" then
      "block100"
    elsif params[:controller].present? && params[:controller] == "customers/sessions" then
      "block100 login-sign"
    elsif params[:controller].present? && params[:controller] == "customers/registrations" then
      "block100 login-sign"
    elsif params[:controller].present? && params[:controller] == "devise/passwords" then
      "block100 login-sign"
    elsif params[:controller].present? && params[:controller] == "customers" && params[:action].present? && params[:action] == "show" then
      "mon-compte"
    elsif params[:controller].present? && params[:controller] == "steps" && params[:action].present? && params[:action] == "show" && params[:id].present? && params[:id] == "step3" then
      "step3"
    elsif params[:controller].present? && params[:controller] == "payment_methods" && params[:action].present? && params[:action] == "update" then
      "step3"
    elsif params[:controller].present? && params[:controller] == "payment_methods" && params[:action].present? && params[:action] == "edit" then
      "step3"
    elsif params[:controller].present? && params[:controller] == "steps" && params[:action].present? && params[:action] == "show" && params[:id].present? && params[:id] == "step4" then
      "step4"
    elsif params[:controller].present? && params[:controller] == "messages" && params[:action].present? && params[:action] == "faq" then
      "contact-faq"
    elsif params[:controller].present? && params[:controller] == "phone_requests" && params[:action].present? && params[:action] == "new" then
      "contact"
    elsif params[:controller].present? && params[:controller] == "messages" && params[:action].present? && params[:action] == "index" then
      "contact-messages"
    elsif params[:controller].present? && params[:controller] == "messages" && params[:action].present? && params[:action] == "show" then
      "contact-messages"
    elsif params[:controller].present? && params[:controller] == "streaming_products" && params[:action].present? && params[:action] == "sample" then
      "video-stream block100"
    elsif params[:controller].present? && params[:controller] == "info" && params[:action].present? && params[:action] == "index" && params[:page_name].present? && params[:page_name] == "conditions" then
      "conditions"
    elsif params[:controller].present? && params[:controller] == "info" && params[:action].present? && params[:action] == "index" && params[:page_name].present? && params[:page_name] == "privacy" then
      "conditions"
    elsif params[:controller].present? && params[:controller] == "info" && params[:action].present? && params[:action] == "index" && params[:page_name].present? && params[:page_name] == "whoweare" then
      "conditions"
    elsif params[:page_name].present? && params[:page_name] == "alacarte" then
      "price-chart price-chart-green three-column"
    elsif params[:page_name].present? && params[:page_name] == "freetrial" then
      "price-chart price-chart-green three-column"
    elsif params[:page_name].present? && params[:page_name] == "unlimited" then
      "price-chart price-chart-blue one-column"
    elsif params[:page_name].present? && params[:page_name] == "adult" then
      "price-chart price-chart-violet one-column"
    elsif params[:page_name].present? && params[:page_name] == "get_connected" then
      "get-connected"
    elsif params[:controller].present? && params[:controller] == "streaming_products" && params[:action].present? && params[:action] == "show" then
      "video-stream-wizard block100"
    elsif params[:controller].present? && params[:controller] == "watchlists" && params[:action].present? && params[:action] == "index" then
      "watchlist"
    elsif params[:controller].present? && params[:controller] == "home" && params[:action].present? && params[:action] == "validation" then
      "adult"
    elsif params[:controller].present? && params[:controller] == "search" && params[:action].present? && params[:action] == "index" then
      "movie-full search-results block100"
    elsif params[:controller].present? && params[:controller] == "photobox" && params[:action].present? && params[:action] == "plans" then
      "carrefour"
    elsif params[:controller].present? && params[:controller] == "carrefourbonus" && params[:action].present? && params[:action] == "plans" then
      "carrefour"
    elsif params[:controller].present? && params[:controller] == "payment_methods" && params[:action].present? && params[:action] == "edit" && params[:type].present? && params[:type] == "credit_card_tvod" then
      "payment-methods"
    elsif params[:controller].present? && params[:controller] == "home" && params[:action].present? && params[:action] == "carrefour" then
      "carrefour"
    elsif params[:controller].present? && params[:controller] == "promotions" && params[:id].present? && params[:id] == "BNPPF" then
      "promotion"
    end
  end

  def render_promo_image_partial(controller)
    case controller
      when "products" then render "layouts/promo_image"
      else
        ""
    end
  end

  def arleady_used_code_messages_helper
    return "Le code est pas valide" if I18n.locale == :fr
    return "De code is niet geldig" if I18n.locale == :nl
    return "The code is not valid" if I18n.locale == :en
  end

  def customer_plan_translator(l, c)
    p = ProductAbo.find_by_products_id(c)
    if l == :fr
      case p.products_id
        when 1 then "Plush Illimité"
        when 5 then "Plush 18+ Illimité"
        when 6 then "Plush a La Carte"
        when 7 then "2 crédits film par mois"
        when 8 then "4 crédits film par mois"
        when 9 then "6 crédits film par mois"
        else " "
      end
     elsif l == :nl
      n = case p.products_id
        when 1 then "Plush Unlimited"
        when 5 then "Plush 18+ Unlimited"
        when 6 then "Plush a La Carte"
        when 7 then "2 credits film per maand"
        when 8 then "4 credits film per maand"
        when 9 then "6 credits film per maand"
        else " "
      end
      n
     elsif l == :en
      e = case p.products_id
        when 1 then "Plush Unlimited"
        when 5 then "Plush 18+ Unlimited"
        when 6 then "Plush a La Carte"
        when 7 then "2 film credits by month"
        when 8 then "4 film credits by month"
        when 9 then "6 film credits by month"
        else " "
      end
      e
    end
  end

  def customer_plan_translator_wister(locale)
    case locale
      when :en then "credits per week"
      when :nl then "credits per week"
      when :fr then "crédits par semaine"
    end
  end

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
      email_data_replace(mail_object.subject, options)
      subject = email_data_replace(mail_object.subject, options)
      message = email_data_replace(mail_object.body, options)
      mail_history.update_attributes(:lstvariable => list)
      Emailer.welcome_email(recipient, subject, message, Rails.env == 'development' ? true : false).deliver
      @ticket = Ticket.new(:customer_id => customer.to_param, :category_ticket_id => mail_object.category_id)
      @ticket.save
      if mail_history
        @message = MessageTicket.new(:ticket => @ticket, :mail_id => mail_id, :data => list, :user_id => 55, :mail_history_id => mail_history.to_param)
      else
        @message = MessageTicket.new(:ticket => @ticket, :mail_id => mail_id, :data => list, :user_id => 55)
      end
      @message.save
  end

  def send_message_public(mail_id, options, locale, email)
    mail_object = Email.by_language(locale).find(mail_id)
    list = ""
    options.each {|k, v|  list << "#{k.to_s.tr("\\","")}:::#{v};;;"}
    email_data_replace(mail_object.subject, options)
    subject = email_data_replace(mail_object.subject, options)
    message = email_data_replace(mail_object.body, options)
    Emailer.public_email(email, subject, message, Rails.env == 'development' ? true : false).deliver
  end

  def email_data_replace(text,options)
    options.each {|key, value|
      r = Regexp.new(key, true)
      text = text.gsub(r, value.to_s)
    }
    text
  end

  def streaming_access?
    session[:country_id] == 22 || session[:country_id] == 131 || session[:country_id] == 0 || session[:country_id] == 161 || (current_customer && current_customer.super_user?) || (current_customer && current_customer.orange_or_wister?)
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
      new_params = new_params.merge(:page_name => I18n.t("routes.infos.params.#{params[:page_name]}", locale: locale)) if params[:page_name] and params[:kind] == :normal
      new_params = new_params.merge(:package => I18n.t("routes.product.params.package.#{params[:package]}", locale: locale)) if params[:package] and params[:kind] == :normal
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
    if cookies[:code]
      cookies[:code]
    else
      code
    end
    #code
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
  def landing_img(code, promotion, params, products_alt_banner, discount_top)
    if params[:kind] == :adult
      path = info_path(:page_name => t('routes.infos.params.alacarte')) #code ? promotion_path(:id => :mobistar2) : new_customer_registration_path(:code => get_code(discount_top.name))
    else
      path = info_path(:page_name => t('routes.infos.params.alacarte')) #new_customer_registration_path(:code => get_code(discount_top.name))
    end
    if promotion && promotion.banner.present?
      src = "http://www.dvdpost.be/images/#{I18n.locale}/#{promotion.banner}"
      image = image_tag(src, :size => '930x400', :class => "img-responsive")

    else
      src = "#{I18n.locale}/banner-promo-hp_tvod#{code ? "_#{code.activation_group_id}" : ''}#{params[:kind] == :adult ? '_adult' : ''}.jpg"
      src_norm = "#{I18n.locale}/banner-promo-hp_tvod#{params[:kind] == :adult ? '_adult' : ''}.jpg"
      src_norm = "http://www.dvdpost.be/images/plush_banner_public/test.php?img=1&lang=#{I18n.locale}&kind=#{params[:kind]}"

      image = FileTest.exist?("/images/#{src}") ? image_tag(src, :size => '930x200', :alt => t(products_alt_banner), :class => "img-responsive") : image_tag(src_norm, :size => '930x200', :alt => t(products_alt_banner), :class => "img-responsive")

    end

    link_to image, path#, :target => "_blank"

  end

end
