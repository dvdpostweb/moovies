module ApplicationHelper

  def switch_locale_link(locale, options=nil)
    link_to locale.to_s.upcase, params.merge(:locale => locale.to_s.downcase), options
  end

end
