class PaymentMethodsController < ApplicationController
  before_filter :authenticate_customer!
  def show
    @choose_partial = params[:type] || 'index'
    @body_id = @choose_partial
  end
  def edit
    @choose_partial = params[:type] || 'index'
    @body_id = @choose_partial
  end

  def update
    if params[:type] == 'credit_card' || params[:type] == 'credit_card_modification'
      internal_com = params[:type]
      @price = 0
      @url_back = edit_customer_payment_methods_url(:customer_id => current_customer.to_param, :type => params[:type])
      @url_ok = edit_customer_payment_methods_url(:customer_id => current_customer.to_param, :type => "#{params[:type]}_finish")
    else
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
    @brand = params[:brand] if params[:brand]
    @com= t 'payment_methods.ogone'
    @alias = "p#{current_customer.to_param}"
    OgoneCheck.create(:orderid => @order_id, :amount => (@price*100).to_i, :customers_id => current_customer.to_param, :context => internal_com, :site => 1, :language_id => Moovies.customer_languages[I18n.locale])
    @hash = Digest::SHA1.hexdigest("#{@order_id}#{(@price*100).to_i}EUR#{Moovies.ogone_pspid[Rails.env]}#{@alias}#{@com}#{Moovies.ogone_pass[Rails.env]}")
  end
end
