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

  def switch_locale_link(locale, options=nil)
    link_to locale.to_s.upcase, params.merge(:locale => locale.to_s.downcase), options
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
      if current_customer && current_customer.customer_attribute.filter_id
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
        current_customer.customer_attribute.update_attributes(:filter_id => current_filter.to_param) if current_customer
      end
    end
    current_filter
  end

end
