class NewfreetrialregistrationloginController < ApplicationController
  layout "application_bootstrap"
  def show
    gon.FREETRIAL_REFERRER_FR = ENV["FREETRIAL_REFERRER_FR"]
    gon.FREETRIAL_REFERRER_NL = ENV["FREETRIAL_REFERRER_NL"]
    gon.FREETRIAL_REFERRER_EN = ENV["FREETRIAL_REFERRER_EN"]
    gon.FREETRIAL_PATH = info_path(:page_name => "freetrial")
    gon.code = params[:code] if params[:code].present?
  end
end
