class Api::V1::Orange::Callbacks::WhaController < ApplicationController

  def success
    #render json: params
    if params[:mp].present?
      render json: params[:mp]
    end
  end

  def cancel
    render json: params
  end
end
