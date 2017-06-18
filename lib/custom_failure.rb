class CustomFailure < Devise::FailureApp
  def redirect_url
    if warden_message == :unconfirmed
      step_path(:id => :confirm)
    elsif params[:return_url]
      params[:return_url]
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