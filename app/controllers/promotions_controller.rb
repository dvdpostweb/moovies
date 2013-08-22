class PromotionsController < ApplicationController
  def show
    @partial = params[:id]
    @partial += "_#{params[:format]}" if params[:format]
    @body_id = @partial
  end

  def update
  end
end