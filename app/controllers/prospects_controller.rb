class ProspectsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => []
  def new
    @prospect = Prospect.new
  end

  def create
    prospect = Prospect.new(params[:prospect])
    if prospect.save
      render :text => "OK"
    else
      render :text => "KO"
    end
  end
end
