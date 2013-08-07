class StepsController < ApplicationController
  def index
    if params[:page_name] == 'step2'
      current_customer.build_address unless current_customer.address
      @countries = Country.all
    end
  end
end
