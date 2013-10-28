class HomeController < ApplicationController
  def index
    @body_id = 'home'
    @meta_title = t("home.index.meta_title", :default => '')
    @meta_description = t("home.index.meta_description", :default => '')
    @new_svod = HomeProduct.where(:country => Product.country_short_name(session[:country_id]), :kind => "svod#{params[:kind] == :adult ? '_adult' : ''}", :locale_id => Moovies.languages[I18n.locale]).order('id asc').includes(:product)
    @new_tvod = HomeProduct.where(:country => Product.country_short_name(session[:country_id]), :kind => "tvod#{params[:kind] == :adult ? '_adult' : ''}", :locale_id => Moovies.languages[I18n.locale]).order('id asc').includes(:product)
    @discount_bottom = Discount.find(Moovies.discount["hp_bottom_#{I18n.locale}_#{params[:kind]}"])
    @newsletter = PublicNewsletter.new(params[:public_newsletter])
    @svod_id = params[:kind] == :adult ? 4 : 1 
    @tvod_id = params[:kind] == :adult ? 5 : 2 
    if current_customer
      @carousel = Landing.by_language(I18n.locale).not_expirated
      @carousel = params[:kind] == :adult ? @carousel.adult : @carousel.private
      @carousel = @carousel.order_rand.limit(1).first
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

end
