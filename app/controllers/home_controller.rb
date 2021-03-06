class HomeController < ApplicationController

  #layout "application_old"

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
    #render :text => open('app/assets/images/blank.gif', "rb").read
  end

  def moodme
  end

  def carrefour
    if customer_signed_in?
      gon.carrefour_activation_code = params[:carrefour_activation_code]
      customer = current_customer
      #@hide_menu = true
      @body_id = 'carrefour'
      @error_abo = false
      @error_code = false
      @error_discount_reused = false
      if request.post?
        if params[:abo].blank? || ![7,8,9,10,11].include?(params[:abo].to_i)
          @error_abo = true
        end
        if params[:abo] === "7"
          activation = Activation.find_by_activation_code(params[:carrefour_code])
          discount = Discount.find_by_discount_code("CFB2FILMS")
          if !customer.discount_reuse?(discount.month_before_reuse)
            @error_discount_reused = true
          else
            customer.tvod_free = customer.tvod_free + discount.tvod_free
            customer.abo_history(38, customer.abo_type_id, discount.to_param)
            customer.code = "CFB2FILMS"
            customer.step = discount.goto_step
            customer.customers_abo = 1
            if customer.save!
              if DiscountUse.create(:discount_code_id => discount.id, :customer_id => customer.to_param, :discount_use_date => Time.now)
                if activation.update_attributes(:customers_id => customer.to_param, :created_at => Time.now.localtime)
                  redirect_to root_path
                end
              end
            end
          end
        elsif params[:abo] === "8"
          activation = Activation.find_by_activation_code(params[:carrefour_code])
          discount = Discount.find_by_discount_code("CFB4FILMS")
          if !customer.discount_reuse?(discount.month_before_reuse)
            @error_discount_reused = true
          else
            customer.tvod_free = customer.tvod_free + discount.tvod_free
            customer.abo_history(38, customer.abo_type_id, discount.to_param)
            customer.code = "CFB4FILMS"
            customer.step = discount.goto_step
            customer.customers_abo = 1
            if customer.save!
              if DiscountUse.create(:discount_code_id => discount.id, :customer_id => customer.to_param, :discount_use_date => Time.now)
                if activation.update_attributes(:customers_id => customer.to_param, :created_at => Time.now.localtime)
                  redirect_to root_path
                end
              end
            end
          end
        elsif params[:abo] === "9"
          activation = Activation.find_by_activation_code(params[:carrefour_code])
          discount = Discount.find_by_discount_code("CFB6FILMS")
          if !customer.discount_reuse?(discount.month_before_reuse)
            @error_discount_reused = true
          else
            customer.tvod_free = customer.tvod_free + discount.tvod_free
            customer.abo_history(38, customer.abo_type_id, discount.to_param)
            customer.code = "CFB6FILMS"
            customer.step = discount.goto_step
            customer.customers_abo = 1
            if customer.save!
              if DiscountUse.create(:discount_code_id => discount.id, :customer_id => customer.to_param, :discount_use_date => Time.now)
                if activation.update_attributes(:customers_id => customer.to_param, :created_at => Time.now.localtime)
                  redirect_to root_path
                end
              end
            end
          end
        elsif params[:abo] === "10"
          activation = Activation.find_by_activation_code(params[:carrefour_code])
          discount = Discount.find_by_discount_code("CFB8FILMS")
          if !customer.discount_reuse?(discount.month_before_reuse)
            @error_discount_reused = true
          else
            customer.tvod_free = customer.tvod_free + discount.tvod_free
            customer.abo_history(38, customer.abo_type_id, discount.to_param)
            customer.code = "CFB8FILMS"
            customer.step = discount.goto_step
            customer.customers_abo = 1
            if customer.save!
              if DiscountUse.create(:discount_code_id => discount.id, :customer_id => customer.to_param, :discount_use_date => Time.now)
                if activation.update_attributes(:customers_id => customer.to_param, :created_at => Time.now.localtime)
                  redirect_to root_path
                end
              end
            end
          end
        elsif params[:abo] === "11"
          activation = Activation.find_by_activation_code(params[:carrefour_code])
          discount = Discount.find_by_discount_code("CFB10FILMS")
          if !customer.discount_reuse?(discount.month_before_reuse)
            @error_discount_reused = true
          else
            customer.tvod_free = customer.tvod_free + discount.tvod_free
            customer.abo_history(38, customer.abo_type_id, discount.to_param)
            customer.code = "CFB10FILMS"
            customer.step = discount.goto_step
            customer.customers_abo = 1
            if customer.save!
              if DiscountUse.create(:discount_code_id => discount.id, :customer_id => customer.to_param, :discount_use_date => Time.now)
                if activation.update_attributes(:customers_id => customer.to_param, :created_at => Time.now.localtime)
                  redirect_to root_path
                end
              end
            end
          end
        end
      end
    else
      @hide_menu = true
      @body_id = 'carrefour'
      @error_abo = false
        @error_code = false
      if request.post?
        if params[:abo].blank? || ![7,8,9,10,11].include?(params[:abo].to_i)
          @error_abo = true
        end
        if params[:abo] === "7"
          redirect_to new_customer_session_path( :activation => params[:carrefour_code], :code => "CFB2FILMS")
        elsif params[:abo] === "8"
          redirect_to new_customer_session_path( :activation => params[:carrefour_code], :code => "CFB4FILMS")
        elsif params[:abo] === "9"
          redirect_to new_customer_session_path( :activation => params[:carrefour_code], :code => "CFB6FILMS")
        elsif params[:abo] === "10"
          redirect_to new_customer_session_path( :activation => params[:carrefour_code], :code => "CFB8FILMS")
        elsif params[:abo] === "11"
          redirect_to new_customer_session_path( :activation => params[:carrefour_code], :code => "CFB10FILMS")
        elsif params[:carrefour_code].present? && params[:carrefour_code] != "CARREFOUR"
          activation = Activation.by_name(params[:carrefour_code]).available.first
          unless activation
            @error_code = true
          end
        elsif
          @error_code = true
        end
        #if @error_code == false && @error_abo == false && params[:carrefour_code] != "CARREFOUR"
        #  redirect_to new_customer_session_path( :code => params[:carrefour_code], :abo => params[:abo]) and return
        #end
      end
    end
  end

  def belgium
    @body_id = 'products_index'
    @body_class = 'reload'
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

  def orangesmsconfirm

  end

end
