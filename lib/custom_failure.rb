class CustomFailure < Devise::FailureApp
  def redirect_url
    if warden_message == :unconfirmed
      step_path(:page_name => :confirm)
    else
      super
    end
  end
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end