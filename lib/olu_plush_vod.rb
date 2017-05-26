require 'httparty'

class OluPlushVod
  include HTTParty
  #format :soap

  base_uri 'https://dev.iostreamproxy.orange.lu:8733/ToolBox/IOStreamProxy/Store/Store_Service?wsdl'

  #attr_accessor :temp, :location, :icon, :desc, :url, :feel_like

  #def initialize(response)
  #  @temp = response['current_observation']['temp_f']
  #  @location = response['current_observation']['display_location']['full']
  #  @icon = response['current_observation']['icon_url']
  #  @desc = response['current_observation']['weather']
  #  @url = response['current_observation']['forecast_url']
  #  @feel_like = response['current_observation']['feelslike_f']
  #end

  def self.eligibility_service(msisdn, sms)
    response = get("/partner_IsEligibleWithSMS?login=#{ENV["OLU_PLUSH_VOD_LOGIN"]}&password=#{ENV["OLU_PLUSH_VOD_LOGIN"]}&msisdn=#{msisdn}&sms=#{sms}")
    if response.success?
      new(response)
    else
      raise response.response
    end
  end

  def self.purchase_service

  end

end