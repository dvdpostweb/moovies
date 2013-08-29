class Customers::ConfirmationsController < Devise::ConfirmationsController
  
  private

    def after_confirmation_path_for(resource_name, resource)
      step_path(:id => 'step2')
    end
end