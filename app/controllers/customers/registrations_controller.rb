class Customers::RegistrationsController < Devise::RegistrationsController

  protected

  def after_inactive_sign_up_path_for(resource)
    step_path(:page_name => :confirm)
  end

end