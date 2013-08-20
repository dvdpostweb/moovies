class PaymentMethodsController < ApplicationController
  before_filter :authenticate_customer!
  def edit
  end

  def update
    if current_customer.promo_type == 'D'
      @promo = Discount.find(current_customer.promo_id)
      internal_com = 'new_discount'
    else
      @promo = Activation.find(current_customer.promo_id)
      internal_com = 'new_activation'
    end
    @order_id = "#{current_customer.to_param}#{Time.now.strftime('%Y%m%d%H%M%S')}"
    @price = @promo.promo_price;
    case I18n.locale
    	when :fr
    		@ogone_language = 'fr_FR'
    		@template_ogone = 'Template_freetrial2FR.htm'
    	when :nl
    		@ogone_language = 'nl_NL';
    		@template_ogone = 'Template_freetrial2NL.htm'
    	when :en
    		@ogone_language = 'en_US';
    		@template_ogone = 'Template_freetrial2EN.htm'
    end
    @brand = params[:brand] if params[:brand]
    @com= t 'payment_methods.ogone'
    
    @url_back = url_for(:controller => 'steps', :action => :show, :id => 'step3', :only_path => false, :protocol => 'http')
    @url_ok = url_for(:controller => 'steps', :action => :show, :id => 'step4', :only_path => false, :protocol => 'http')
    OgoneCheck.create(:orderid => @order_id, :amount => (@price*100).to_i, :customers_id => current_customer.to_param, :context => internal_com, :site => 1)
    @hash = Digest::SHA1.hexdigest("#{@order_id}#{(@price*100).to_i}EURdvdpostogonetest#{current_customer.to_param}#{@com}KILLBILL1$metropolis")
  end
end
