module InfoHelper
  def float_html(number)
    if number.nil?
      res = ""
    else
      r = number.to_s.split(/\./)
      res = "<span class='unite'>#{r[0]}</span>"
      res += "<span class='cents'>,#{r[1]}</span>".html_safe
    end
    res.html_safe
  end
  
end
