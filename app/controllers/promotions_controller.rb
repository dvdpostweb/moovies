class PromotionsController < ApplicationController
  before_filter :get_data
  def show
  end

  def create
    code = params[:code]
    @discount = Discount.by_name(code).available.first
    @activation = Activation.by_name(code).available.first
    if @discount.nil? && @activation.nil?
      @error = true
      render :show
    else
      redirect_to new_customer_registration_path(:code => code)
    end
  end
  private
  def get_data
    @partial = params[:id]
    @partial += "_#{params[:format]}" if params[:format]
    @body_id = @partial
  end
end