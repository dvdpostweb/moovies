class InfoController < ApplicationController
  def index
    @body_id = params[:page_name]
    if params[:page_name] == 'abo'
      @discount_unlimited = Discount.find(1)
      
    end
  end
end
