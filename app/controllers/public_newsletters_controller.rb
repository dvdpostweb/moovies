class PublicNewslettersController < ApplicationController
  def new
    @newsletter = PublicNewsletter.new
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    @newsletter = PublicNewsletter.new(params[:public_newsletter])
    if @newsletter.save
      #products_seen_read.each do |product|
      #  @newsletter.public_newsletter_products.create(:product_id =>product)
      #end
      
      cookies[:public_newsletter_id] = { :value => @newsletter.to_param, :expires => 2.months.from_now }
      flash[:notice] = t('public_newsletters.create.email_save')
      respond_to do |format|
        format.html {redirect_to root_localize_path(:promo => params[:promo])}
        format.js {render :layout => false}
      end
    else
      @body_id = 'home'
      @discount_top = Discount.find(Moovies.discount["hp_top_#{I18n.locale}"])
      @discount_bottom = Discount.find(Moovies.discount["hp_bottom_#{I18n.locale}"])
      @newsletter = PublicNewsletter.new(params[:public_newsletter])
      @new_svod = HomeProduct.where(:country => Product.country_short_name(session[:country_id]), :kind => :svod, :locale_id => Moovies.languages[I18n.locale]).order('id asc').includes(:product)
      @new_tvod = HomeProduct.where(:country => Product.country_short_name(session[:country_id]), :kind => :tvod, :locale_id => Moovies.languages[I18n.locale]).order('id asc').includes(:product)
      
      respond_to do |format|
        format.html {render :template => 'home/index'}
        format.js {render :action => :new, :layout => false}
      end
    end
  end
end