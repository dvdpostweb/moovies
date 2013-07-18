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

end
