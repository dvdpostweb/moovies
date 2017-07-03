class Api::V1::Orange::Callbacks::IosController < API::V1::BaseController

  def orangemobile
    if params[:imdb_id].present?
      sp_chromecast_data = ActiveRecord::Base.connection.exec_query %Q{CALL sp_chromecast_data(#{params[:imdb_id]})}
      render json: sp_chromecast_data
    end
  end

  def ioscallback
    render json: params
  end

end