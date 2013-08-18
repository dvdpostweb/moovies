class Customers::ConfirmationsController < Devise::ConfirmationsController
  
  private

    def after_confirmation_path_for(resource_name, resource)
      current_customer.update_column(:customers_registration_step, 31)
      step_path(:id => 'step2')
    end
end