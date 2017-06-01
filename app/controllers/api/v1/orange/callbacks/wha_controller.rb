class Api::V1::Orange::Callbacks::WhaController < ApplicationController

  def success
    render json: "/api/v1/orange/wha/callbacks/wha/success"
  end

  def cancel
    render json: "/api/v1/orange/wha/callbacks/wha/cancel"
  end
end
