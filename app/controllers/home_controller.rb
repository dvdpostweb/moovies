class HomeController < ApplicationController
  def index
    @body_id = 'home'
    @meta_title = t("home.index.meta_title", :default => '')
    @meta_description = t("home.index.meta_description", :default => '')
    @new_svod = HomeProduct.where(:country => Product.country_short_name(session[:country_id]), :kind => "svod#{params[:kind] == :adult ? '_adult' : ''}", :locale_id => Moovies.languages[I18n.locale]).order('id asc').includes(:product => [Product.get_vod_online_name(session[:country_id]),"descriptions_#{I18n.locale}", :svod_dates])
    @new_tvod = HomeProduct.where(:country => Product.country_short_name(session[:country_id]), :kind => "tvod#{params[:kind] == :adult ? '_adult' : ''}", :locale_id => Moovies.languages[I18n.locale]).order('id asc').includes(:product => [Product.get_vod_online_name(session[:country_id]),"descriptions_#{I18n.locale}", :svod_dates])
    @discount_bottom = Discount.find(Moovies.discount["hp_bottom_#{I18n.locale}_#{params[:kind]}"])
    @newsletter = PublicNewsletter.new(params[:public_newsletter])
    @svod_id = params[:kind] == :adult ? 4 : 1 
    @tvod_id = params[:kind] == :adult ? 5 : 2
    @carousel = Landing.by_language(I18n.locale).not_expirated.order_id
    if current_customer
      @carousel = params[:kind] == :adult ? @carousel.adult : @carousel.private
      @vod_wishlist = current_customer.products.collect(&:products_id)
    else
      @carousel = params[:kind] == :adult ? @carousel.adult_public : @carousel.public
    end
  end

  def validation
    if params[:valid] == "1"
      session[:adult] = 1
      begin
        redirect_to session['current_uri']
      rescue => e
        redirect_to root_localize_path
      end
    end
  end

  def flag
    if !params['mail_id'].nil?
      histo = MailHistory.find(params['mail_id'])
      histo.update_attributes(:mail_opened => histo.mail_opened + 1, :mail_opened_date => Time.now)
      MessageTicket.find_by_mail_history_id(params['mail_id']).update_attributes(:is_read => 1)
    end
    render :text => open('app/assets/images/blank.gif', "rb").read
  end

  def moodme
  end
  def belgium
    @body_id = 'products_index'
    @countries = ProductCountry.visible.ordered
    per_page = params[:format] == 'json' ? 5000 : 50
    new_params = session[:sexuality] == 0 ? params.merge(:per_page => per_page, :country_id => session[:country_id], :hetero => 1, :includes => ["descriptions_#{I18n.locale}", 'vod_online_be']) : params.merge(:per_page => 50, :country_id => session[:country_id], :includes => ["descriptions_#{I18n.locale}", 'vod_online_be'])
    tvod_package_id = params[:kind] == :adult ? 5 : 2
    svod_package_id = params[:kind] == :adult ? 4 : 1
    
    respond_to do |format|
      format.html do 
        @country =        Product.filter(nil, new_params.merge(:belgium => 1,  :package => Moovies.packages.invert[tvod_package_id]))
        @actor =          Product.filter(nil, new_params.merge(:belgium => 2,  :package => Moovies.packages.invert[tvod_package_id]))
        @director =       Product.filter(nil, new_params.merge(:belgium => 3,  :package => Moovies.packages.invert[tvod_package_id]))
        @land =           Product.filter(nil, new_params.merge(:belgium => 4,  :package => Moovies.packages.invert[tvod_package_id]))
      end 
      format.json
        case params[:type]
        when "actor"
          @list =          Product.filter(nil, new_params.merge(:belgium => 2,  :package => Moovies.packages.invert[tvod_package_id]))
        when "director"
          @list =       Product.filter(nil, new_params.merge(:belgium => 3,  :package => Moovies.packages.invert[tvod_package_id]))
        when "land"
          @list =           Product.filter(nil, new_params.merge(:belgium => 4,  :package => Moovies.packages.invert[tvod_package_id]))
        else
          @list =        Product.filter(nil, new_params.merge(:belgium => 1,  :package => Moovies.packages.invert[tvod_package_id]))
        end

    end
  end
end
