class HomeController < ApplicationController
  def index
    @body_id = 'home'
    @new_svod = HomeProduct.where(:country => 'be', :kind => :svod, :locale_id => Moovies.languages[I18n.locale]).order('id asc').includes(:product)
    @new_tvod = HomeProduct.where(:country => 'be', :kind => :tvod, :locale_id => Moovies.languages[I18n.locale]).order('id asc').includes(:product)
    @discount_bottom = Discount.find(Moovies.discount["hp_bottom_#{I18n.locale}"])
    @newsletter = PublicNewsletter.new(params[:public_newsletter])
  end

  def validation
    if params[:valid] == "1"
      session[:adult] = 1
      begin
        redirect_to session['current_uri']
      rescue => e
        redirect_to products_path(:package => Moovies.packages.invert[4], :kind => :adult)
      end
    end
  end

end
