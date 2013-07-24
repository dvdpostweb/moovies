class HomeController < ApplicationController
  def index
    @body_id = 'home'
    @new_svod = Product.limit 6
    @new_tvod = Product.where('products_id >500').limit 6
  end
end
