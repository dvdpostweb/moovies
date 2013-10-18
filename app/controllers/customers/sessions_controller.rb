class Customers::SessionsController < Devise::SessionsController
  
  def create
    super
    if current_customer && params[:customer] && params[:customer][:code]
      customer = current_customer
      customer.code = params[:customer][:code]
      customer.save
    end
    
  end
end