class Api::V1::Orange::AuthController < API::V1::BaseController

  def ppv
    render json: params
  end

end