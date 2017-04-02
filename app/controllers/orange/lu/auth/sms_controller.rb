class Orange::Lu::Auth::SmsController < ApplicationController

  def authorization
    if params[:code].present? && params[:code] == "2FILMS"
      gon.product_id = 2
    elsif params[:code].present? && params[:code] == "4FILMS"
      gon.product_id = 4
    elsif params[:code].present? && params[:code] == "6FILMS"
      gon.product_id = 6
    end
  end

end
