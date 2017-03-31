class Orange::Lu::Api::WebserviceController < ApplicationController

  def is_eligable
    render json: "is_eligable"
  end

  def orange_purchase
    render json: "orange_purchase"
  end

end