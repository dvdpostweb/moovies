require 'jwt'

class Wister::AuthController < API::V1::BaseController

  def jwt
    if params[:tokenwister].present?
      decoded_token = JWT.decode params[:tokenwister], nil, false, { :algorithm => 'HS256' }
      decoded_token.split(/,/).to_a
      email = decoded_token[0]["email"]
      customer = Customer.find_by_email(email)
      if customer.present?
        sign_in(customer)
        redirect_to root_localize_path
      end
    else
      render json: "NO ACCESS TOKEN!!!"
    end
  end

  def token_creator
    if params[:email].present?
      exp = Time.now.to_i + 4 * 3600
      payload = {
        :email => params[:email],
        :time => exp
      }
      hmac_secret = 'WisterAndPlushAreAwesome2017'
      token = JWT.encode payload, hmac_secret, 'HS256'
      render json: token
    else
      render json: "NO EMAIL!!!"
    end
  end

end
