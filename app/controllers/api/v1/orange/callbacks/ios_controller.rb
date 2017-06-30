class Api::V1::Orange::Callbacks::IosController < API::V1::BaseController

  def orangemobile
    render json: params
  end

end