class Orange::Lu::Auth::SmsController < ApplicationController

  def authorization
    if params[:code].present? && params[:code] == "2FILMS"
      gon.products_id = 7
    elsif params[:code].present? && params[:code] == "4FILMS"
      gon.products_id = 8
    elsif params[:code].present? && params[:code] == "6FILMS"
      gon.products_id = 9
    elsif params[:code].present? && params[:code] == "SVOD"
      gon.products_id = 1
    elsif params[:code].present? && params[:code] == "SVOD_ADULT"
      gon.products_id = 5
    elsif params[:moovie_id].present?
      gon.products_id = params[:moovie_id]
    end
    gon.code = params[:code]
    gon.orange_registration_path = orange_lu_auth_sms_registration_path(:orange => "new_customer")
  end

  def registration
    if params[:code].present? && params[:code] == "2FILMS"
      gon.products_id = 7
    elsif params[:code].present? && params[:code] == "4FILMS"
      gon.products_id = 8
    elsif params[:code].present? && params[:code] == "6FILMS"
      gon.products_id = 9
    elsif params[:code].present? && params[:code] == "SVOD"
      gon.products_id = 1
    elsif params[:code].present? && params[:code] == "SVOD_ADULT"
      gon.products_id = 5
    elsif params[:moovie_id].present?
      gon.products_id = params[:moovie_id]
    end
    gon.code = params[:code]
    gon.phone_number = params[:phone_number]
  end

end
