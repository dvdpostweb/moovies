module ApplicationHelper
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
        current_customer.customer_attribute.update_attributes(:filter_id => nil) if current_customer
        cookies.delete :filter_id
      end
      if !options.empty?
        current_filter.update_with_defaults(options)
      end
    else
      if current_customer && current_customer.filter_id
        cookies[:filter_id] = { :value => current_customer.customer_attribute.filter_id, :expires => 1.year.from_now }
        current_filter = SearchFilter.get_filter(current_customer.customer_attribute.filter_id)
        unless current_filter.to_param
          current_customer.customer_attribute.update_attributes(:filter_id => nil) if current_customer
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
  def redirect_after_registration(path = nil)
    #if current_customer
    #  if current_customer.customers_registration_step.to_i == 31
    #    if (params['controller'] == 'steps' && params[:id].to_i == 2) || (params[:controller] == 'customers' && params[:action] == 'update')
    #    else
    #      redirect_to step_path(:id => 2)
    #    end
    #  elsif current_customer.customers_registration_step.to_i == 21
    #    if (params['controller'] == 'steps' && params[:id].to_i == 1)
    #    else
    #      redirect_to step_path(:id => 1)
    #    end
    #  elsif current_customer.customers_registration_step.to_i == 33
    #    if (params['controller'] == 'steps' && params[:id].to_i == 3) || (params[:controller] == 'ogones' && params[:action] == 'show')
    #    else
    #      redirect_to step_path(:id => 3)
    #    end
    #  elsif current_customer.customers_registration_step.to_i == 90
    #    if (params['controller'] == 'steps' && params[:id].to_i == 5) || (params['controller'] == 'steps' && params[:id].to_i == 1 && params[:action] == 'update')
    #    else
    #      redirect_to step_path(:id => 5)
    #    end
    #  elsif params[:controller] == 'steps' && params[:id].to_i != 4 && (current_customer.customers_registration_step.to_i == 100 || current_customer.customers_registration_step.to_i == 95)
    #    redirect_to root_path
    #  elsif current_customer.customers_registration_step.to_i != 100  && current_customer.customers_registration_step.to_i != 95
    #    redirect_to php_path
    #  elsif path
    #    redirect_to path
    #  end
    #end
  
    #if current_customer
    #  if current_customer.customers_registration_step.to_i == 80
    #    if params[:controller] != 'shops' && params[:controller] != 'shopping_carts' && params[:controller] != 'shopping_orders' && !(params[:controller] == 'info' && params[:page_name] == 'buy') && !(params[:controller] == 'info' && params[:page_name] == 'withdrawal_period') && params[:controller] != 'phone_requests' && params[:action] != 'validation'
    #      redirect_to shop_path(:locale => params[:locale], :kind => :normal) and return
    #    end
    #  elsif current_customer.customers_registration_step.to_i == 90
    #    redirect_to customers_path #to do php_path("step_member_choice.php")
    #  elsif current_customer.customers_registration_step.to_i != 100  && current_customer.customers_registration_step.to_i != 95
    #    redirect_to customer_path
    #  end
    #end
  end
  
  def streaming_access?
    true
  end

end
