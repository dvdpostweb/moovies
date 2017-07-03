class Api::V1::Orange::Callbacks::IosController < API::V1::BaseController

  def orangemobile
    if params[:imdb_id].present?
      sp_chromecast_data = ActiveRecord::Base.connection.exec_query %Q{CALL sp_chromecast_data(#{params[:imdb_id]})}
      render json: sp_chromecast_data
    end
  end

  def ioscallback
    customer = Customer.find(params[:cn])
    product = Product.find(params[:products_id])
    if customer.present? && product.present?
      redirect_to streaming_product_path(:id => product.imdb_id, :season_id => product.season_id, :episode_id => product.episode_id)
    end
  end

end