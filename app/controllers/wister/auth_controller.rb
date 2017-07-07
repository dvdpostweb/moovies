class Wister::AuthController < API::V1::BaseController

  def jwt
    render json: params
  end

end
