class HomeController < ApplicationController
  def index
    @body_id = 'home'
    @new_svod = Product.limit 6
    @new_tvod = Product.where('products_id >500').limit 6
    @discount_top = Discount.find(Moovies.discount["hp_top_#{I18n.locale}"])
    @discount_bottom = Discount.find(Moovies.discount["hp_bottom_#{I18n.locale}"])
    @newsletter = PublicNewsletter.new(params[:public_newsletter])
  end
end
