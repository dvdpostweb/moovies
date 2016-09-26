class Api::V1::FacebookController < ApplicationController
  def activation
    render json: {status: 9, message: "#{cookies[:code]}"}
  end
end
