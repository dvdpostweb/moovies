class Api::V1::Orange::Callbacks::WhaController < ApplicationController

  def success
    render json: params[:m]
  end

  def cancel
    render json: params
  end
end
