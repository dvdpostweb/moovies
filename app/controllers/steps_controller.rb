class StepsController < ApplicationController
  before_filter :authenticate_customer!, :unless => :confirmation?
  def index
    if params[:page_name] == 'step2'
      current_customer.build_address unless current_customer.address
      @countries = Country.all
    end
  end
  protected
  def confirmation?
    params[:page_name] == 'confirm'
  end
end
