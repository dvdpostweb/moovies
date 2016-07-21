class Customers::SessionsController < Devise::SessionsController

  def new
  	@success_promotion_message = "Profitez de votre promotion" if I18n.locale == :fr
    @success_promotion_message = "Geniet van uw promotie" if I18n.locale == :nl
    @success_promotion_message = "Enjoy your promotion" if I18n.locale == :en
    gon.code = params[:code]
    #gon.root_localize_path = root_localize_path
    #gon.moovie_id = params[:moovie_id]

    product = Product.where(:products_id  => params[:moovie_id]).first

    if product
      gon.root_localize_path = product_path(:id => product.to_param)
    else
      gon.root_localize_path = root_localize_path
    end

    super
  end

end
