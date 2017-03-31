class Orange::Lu::Api::WebserviceController < ApplicationController

  def is_eligable
    render json: HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangeIseligable?customers_id=0&mobileNumber=32642013990&SMSCodeMessage=%22dsgfdag%22&products_id=1758468")
  end

  def orange_purchase
    render json: HTTParty.get("https://www.plush.be:2355/WcfService/http/OrangePurchase?customers_id=0&mobileNumber=32642013990&price=4.99&products_id=1")
  end

end