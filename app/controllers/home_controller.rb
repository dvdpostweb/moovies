class HomeController < ApplicationController
  def index
    @body_id = 'home'
    @new_svod = HomeProduct.where(:country => 'be', :kind => :svod, :locale_id => Moovies.languages[I18n.locale]).includes(:product)
    @new_tvod = HomeProduct.where(:country => 'be', :kind => :tvod, :locale_id => Moovies.languages[I18n.locale]).includes(:product)
    @discount_top = Discount.find(Moovies.discount["hp_top_#{I18n.locale}"])
    @discount_bottom = Discount.find(Moovies.discount["hp_bottom_#{I18n.locale}"])
    @newsletter = PublicNewsletter.new(params[:public_newsletter])
  end
end
