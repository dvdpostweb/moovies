class PaymentMethodsController < ApplicationController
  before_filter :authenticate_customer!
  def show
    @choose_partial = params[:type] || 'index'
    @body_id = @choose_partial
  end
  def edit
    if params[:product_id]
      @product = Product.find(params[:product_id])
      if @product.svod?
        redirect_to root_localize_path() and return
      end
    end
    @choose_partial = params[:type] || 'index'
    @body_id = @choose_partial
  end

  def update
    if params[:type] == 'credit_card' || params[:type] == 'credit_card_modification'
      internal_com = params[:type]
      @price = 0
      @url_back = edit_customer_payment_methods_url(:customer_id => current_customer.to_param, :type => params[:type])
      @url_ok = edit_customer_payment_methods_url(:customer_id => current_customer.to_param, :type => "#{params[:type]}_finish")
      @com = t 'payment_methods.ogone_modification'
      product_id = 0
      imdb_id = 0
      season_id = 0
      episode_id = 0
    elsif params[:type] == 'tvod'
      internal_com = 'tvod'
      @product = Product.find(params[:product_id])
      if @product.svod?
        redirect_to root_localize_path() and return
      end
      @product = Product.find(params[:product_id])
      @url_back = product_url(:id => @product.id)
      @url_ok = streaming_product_url(:id => @product.imdb_id, :season_id => @product.season_id, :episode_id => @product.episode_id)
      @price = @product.get_vod_online(session[:country_id]).first.tvod_price
      @com = t 'payment_methods.tvod', :default => 'payment plush tvod'
      product_id = @product.imdb_id
      imdb_id = @product.imdb_id
      season_id = @product.season_id
      episode_id = @product.episode_id
    else
      @com= t 'payment_methods.ogone'
      if current_customer.promo_type == 'D'
        @promo = Discount.find(current_customer.promo_id)
        internal_com = 'new_discount'
      else
        @promo = Activation.find(current_customer.promo_id)
        internal_com = 'new_activation'
      end
      @price = @promo.promo_price
      @url_back = url_for(:controller => 'steps', :action => :show, :id => 'step3', :only_path => false, :protocol => 'http')
      @url_ok = url_for(:controller => 'steps', :action => :show, :id => 'step4', :only_path => false, :protocol => 'http')

      product_id = 0
      imdb_id = 0
      season_id = 0
      episode_id = 0

    end

    @order_id = "p#{current_customer.to_param}#{Time.now.strftime('%Y%m%d%H%M%S')}"

    case I18n.locale
    	when :fr
    		@ogone_language = 'fr_FR'
    		@template_ogone = URI.join(root_url, 'template_fr.htm')
    	when :nl
    		@ogone_language = 'nl_NL'
    		@template_ogone = URI.join(root_url, 'template_nl.htm')
    	when :en
    		@ogone_language = 'en_US'
    		@template_ogone = URI.join(root_url, 'template_en.htm')
    end
    if params[:brand]
      @brand = params[:brand]
      @pm = case @brand
        when 'PAYPAL'
          'PAYPAL'
        when 'iDEAL'
          'iDEAL'
        when 'Belfius Direct Net'
          'Belfius Direct Net'
        when 'ING HomePay'
          'ING HomePay'
        when 'DirectEbankingBE'
          'DirectEbankingBE'
        when 'DirectEbankingNL'
          'DirectEbankingNL'
        else
          'CreditCard'
      end
    end

    @alias = "p#{current_customer.to_param}"

    if current_customer.have_freetrial_codes?
      list = {
        "Account.PSPID" => ENV["OGONE_PSPID"],
        "Alias.AliasId" => @alias,
        "Alias.OrderId" => @order_id,
        "Alias.StorePermanently" => "Y",
        "Card.Brand" => @brand.upcase,
        "Card.PaymentMethod" => @pm,
        "Layout.Language" => @ogone_language,
        "Parameters.AcceptUrl" => ENV["OGONE_PARAMETERS_ACCEPTURL"],
        "Parameters.ExceptionUrl" => ENV["OGONE_PARAMETERS_EXCEPTIONURL"]
      }
      list = list.sort
      s = list.map { |k,v| "#{k.to_s.upcase}=#{v}#{ENV["OGONE_PASSWORD"]}" }.join()
      Rails.logger.debug s.inspect
      @hash = Digest::SHA1.hexdigest(s)
    else
      OgoneCheck.create(:orderid => @order_id, :amount => (@price*100).round, :customers_id => current_customer.to_param, :context => internal_com, :site => 1, :language_id => Moovies.customer_languages[I18n.locale], :imdb_id => imdb_id, :season_id => season_id, :episode_id => episode_id, :source_id => params[:source])
      list = {:COM => @com, :ALIAS => @alias, :AMOUNT => (@price*100).round, :CURRENCY => 'EUR', :LANGUAGE => @ogone_language, :ORDERID => @order_id, :PSPID => Moovies.ogone_pspid[Rails.env], :CN => current_customer.name_without_accent, :ALIASUSAGE => ".", :DECLINEURL => @url_back, :EXCEPTIONURL => @url_back, :CANCELURL => @url_back, :CATALOGURL => @url_back, :ACCEPTURL => @url_ok, :TP => @template_ogone}
      list = list.merge(:PM => @pm, :BRAND => @brand) if !@brand.nil?
      list = list.sort
      string = list.map { |k,v| "#{k.to_s.upcase}=#{v}#{Moovies.ogone_pass[Rails.env]}" }.join()
      Rails.logger.debug string.inspect
      @hash = Digest::SHA1.hexdigest(string)
    end
  end
end
