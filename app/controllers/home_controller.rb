class HomeController < ApplicationController
  def index
    if params[:kind] == :adult
      redirect_to products_path(:package => Moovies.packages.invert[4], :kind => :adult)
    end
    @body_id = 'home'
    @new_svod = HomeProduct.where(:country => 'be', :kind => :svod, :locale_id => Moovies.languages[I18n.locale]).order('id asc').includes(:product)
    @new_tvod = HomeProduct.where(:country => 'be', :kind => :tvod, :locale_id => Moovies.languages[I18n.locale]).order('id asc').includes(:product)
    @discount_bottom = Discount.find(Moovies.discount["hp_bottom_#{I18n.locale}"])
    @newsletter = PublicNewsletter.new(params[:public_newsletter])
    @carousel = Landing.by_language(I18n.locale).not_expirated.private.order_rand.limit(1).first if current_customer
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

  def flag
    if !params['mail_id'].nil?
      histo = MailHistory.find(params['mail_id'])
      histo.update_attributes(:mail_opened => histo.mail_opened + 1, :mail_opened_date => Time.now)
      MessageTicket.find_by_mail_history_id(params['mail_id']).update_attributes(:is_read => 1)
    end
    render :text => open('app/assets/images/blank.gif', "rb").read
  end

end
