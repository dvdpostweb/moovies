module DeviseHelper

  def devise_error_messages!

    return "" if resource.errors.empty?
    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg.html_safe) }.join
    # empty out error messages so they don't linger
    resource.errors.clear

    # remove close button option for now - CSS conflict with facebox
    html = <<-HTML
  <div id="error_explanation">
  <ul>#{messages}</ul>
  </div>
    HTML
    html.html_safe
  end
end