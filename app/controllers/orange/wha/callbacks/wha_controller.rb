class Orange::Wha::Callbacks::WhaController < ApplicationController

  def success

    render json: "/orange/wha/callbacks/wha/success"

  end

  def cancel
    render json: "/orange/wha/callbacks/wha/cancel"
  end

end
