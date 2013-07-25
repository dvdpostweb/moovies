class SearchController < ApplicationController
  def index
    @filter = view_context.get_current_filter({})
    new_params = session[:sexuality] == 0 ? params.merge(:per_page => 15, :country_id => session[:country_id], :hetero => 1) : params.merge(:per_page => 15, :country_id => session[:country_id])
    @products = Product.filter(@filter, new_params)
    @directors = params[:kind] == :normal ?  Director.search_clean(params[:search], params[:page]) : 0
    @actors = Actor.search_clean(params[:search], params[:kind], params[:page])
    
  end
end
