class Customers::ConfirmationsController < Devise::ConfirmationsController
  
  private

    def after_confirmation_path_for(resource_name, resource)
      if resource.step == 100
        root_localize_path
      else
        step_path(:id => 'step2')
      end
    end
end