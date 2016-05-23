class CustomersController < ApplicationController
  #layout :choose_layout_social
  before_filter :authenticate_customer!, :unless => :no_customer?
  def index
    redirect_to customer_path(:id => current_customer)
  end
  def show
    @body_id = 'moncompte'
    @customer = current_customer
    env = Rails.env == 'staging' || Rails.env == 'development' ? 'staging' :  Rails.env
    @review_count = current_customer.reviews.approved.joins("INNER JOIN plush_#{env}.products ON `products`.`imdb_id` = `reviews`.`imdb_id`").where(:products => {:products_type => Moovies.product_kinds[params[:kind]], :products_status => [-2,0,1]}).count
    @classic_count = current_customer.vod_wishlists.joins(:products, :streaming_products).where("streaming_products.available = 1 and products_status != -1 and products_type = :type and country = :country", {:type => Moovies.product_kinds[:normal], :country => Product.country_short_name(session[:country_id])}).count(:imdb_id, :distinct => true)
    @adult_count = current_customer.vod_wishlists.joins(:products, :streaming_products).where("streaming_products.available = 1 and products_status != -1 and products_type = :type and country = :country", {:type => Moovies.product_kinds[:adult], :country => Product.country_short_name(session[:country_id])}).count(:imdb_id, :distinct => true)
  end

  def edit
    @customer = current_customer
    if request.xhr?
      render :layout => false
    end
  end

  def update
    current_customer.build_address unless current_customer.address
    if params[:customer][:address_attributes]
      params[:customer][:address_attributes][:first_name] = params[:customer][:first_name]
      params[:customer][:address_attributes][:last_name] = params[:customer][:last_name]
      params[:customer][:address_attributes][:gender] = params[:customer][:gender]
      params[:customer][:address_attributes][:customers_id] = current_customer.to_param
    end
    params[:customer][:nickname] = params[:customer][:first_name] if current_customer.nickname.nil? && !params[:customer][:first_name].nil?
    @customer = current_customer
    @customer.attributes = params[:customer]
    if @customer.save(context: :publish)
      flash[:notice] = t(:customer_modify) if current_customer.step == 100
      if current_customer.step == 31
        current_customer.update_column(:customers_registration_step, current_customer.samsung_codes.unvalidated.empty? ? 33 : 32)
      end
      if request.xhr?
        render :layout => false
      else
        redirect_after_registration(customer_path)
      end
    else
      @countries = Country.all
      if request.xhr?
        render :action => :edit, :layout => false
      else
        if current_customer.step == 31
          @step_id = 'step2'
          render :template => "steps/show"
        elsif current_customer.step == 33
          @step_id = 'step3'
          render :template => "steps/show"
        end
      end
    end
  end

  def reactive
    @hide_menu = true
    if params[:code] || cookies[:code]
      code = params[:code] || cookies[:code]
      @discount = Discount.by_name(code).available.first
      @activation = Activation.by_name(code).available.first
      if @discount
        @promo = @discount
        cookies[:code] = { value: code, expires: 15.days.from_now }
      elsif @activation
        @promo = @activation
        cookies[:code] = { value: code, expires: 15.days.from_now }
      else
        @default_code = Discount.find(Moovies.discount["svod_#{I18n.locale}"]).name
        cookies[:code] = { value: @default_code, expires: 15.days.from_now } 
      end
    end
  end
  def promotion
    @hide_menu = true
    if params[:code]
      @code = params[:code]
      @discount = Discount.by_name(@code).available.first
      @activation = Activation.by_name(@code).available.first
      if @discount
        @promo = @discount
      elsif @activation
        @promo = @activation
      end
    end
  end

  def newsletter
    @customer = current_customer
    @customer.newsletter!(params[:type], params[:value])
    if params[:type] == 'newsletter'
      data = @customer.newsletter
    else
      data = @customer.newsletter_parnter
    end
    if request.xhr?
      render :partial => 'customers/show/active', :locals => {:active => data, :type => params[:type]}
    else
      redirect_to customer_path(:id => current_customer.to_param)
    end
  end
  
  def newsletters_x
    #to do
    @customer = current_customer
    @customer.update_attribute(:newsletters_x, params[:value])
    respond_to do |format|
      format.html do
        redirect_to customer_path(:id => current_customer.to_param)
      end
      format.js {render :partial => 'customers/show/newsletters_x', :locals => {:newsletters_x => @customer.newsletters_x}}
    end
  end
  
  def newsletter_x
    respond_to do |format|
      format.html 
      format.js {render :layout => false}
    end
  end
  
  def sexuality
    @customer = current_customer
    @customer.update_attribute(:sexuality, params[:value])
    session[:sexuality] = params[:value].to_i
    redirect_to root_localize_path
  end

  def unsubscribe
    if params[:type] == 'profile_part'
      customer = Customer.find_by_email(params[:email])
      if customer
        customer.update_attribute(:newsletter_parnter, false)
      end
      vision = EmailVisionCustomer.find_by_email(params[:email])
      if vision
        vision.update_attribute(:newsletters_partners, false)
      end
      
    end
  end

  def back_to_tvod
    if current_customer.subscription && current_customer.subscription.product_id == 6
      current_customer.abo_type_id = 6
      current_customer.next_abo_type_id = 6
      current_customer.step = 100
      current_customer.abo_active = 1
      current_customer.auto_stop = 0
      current_customer.subscription_expiration_date = nil
      current_customer.save(:validate => false)
    end
    redirect_to root_localize_path
  end
  protected
   def no_customer?
     params[:action] == 'reactive' || params[:action] == 'promotion'
   end
end
