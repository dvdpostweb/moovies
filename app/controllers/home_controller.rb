class HomeController < ApplicationController
  def index
    @body_id = 'home'
    @new_svod = HomeProduct.where(:country => 'be', :kind => :svod, :locale_id => Moovies.languages[I18n.locale]).order('id asc').includes(:product)
    @new_tvod = HomeProduct.where(:country => 'be', :kind => :tvod, :locale_id => Moovies.languages[I18n.locale]).order('id asc').includes(:product)
    @discount_bottom = Discount.find(Moovies.discount["hp_bottom_#{I18n.locale}"])
    @newsletter = PublicNewsletter.new(params[:public_newsletter])
  end
end
