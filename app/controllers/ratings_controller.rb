class RatingsController < ApplicationController
  def create
    @product = Product.both_available.find(params[:product_id])
    @product.ratings.create(:customer => current_customer, :value => params[:value])
    current_customer.seen_products << @product
    Customer.send_evidence('Rating', params[:product_id], current_customer, request.remote_ip, {:rating => params[:value]})
    if params[:recommendation].to_i == 1
      expiration_recommendation_cache
    end
    if request.xhr?
      render :partial => 'products/rating', :locals => {:product => @product, :background => params[:background], :size => params[:size]}
    else
      redirect_to product_path(:id => @product.to_param, :source => params[:source])
    end
  end
end
