class PromotionsController < ApplicationController
  def show
    @partial = params[:id]
    @partial += "_#{params[:format]}" if params[:format]
  end

  def update
  end
end