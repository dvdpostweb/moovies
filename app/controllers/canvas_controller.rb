class CanvasController < ApplicationController

  layout "canvas"
  
  before_filter :detect_facebook_post!
  before_filter :find_product, :except => [:index, :drop_cached]

  def index
    if params[:category_id] && params[:filters].nil? || (params[:filters] && params[:filters][:category_id].nil?)
      params[:filters] = Hash.new if params[:filters].nil?
      params[:filters][:category_id] = params[:category_id]
    end
    if params[:package] == t('routes.product.params.package.unlimited')
      params[:package] = Moovies.packages.invert[1]
    end
    if params[:package] == t('routes.product.params.package.tvod')
      params[:package] = Moovies.packages.invert[2]
    end
    if params[:filters] && params[:filters][:view_mode]
      params[:view_mode] = params[:package] == Moovies.packages.invert[2] || params[:package] == Moovies.packages.invert[5] ? "tvod_#{params[:filters][:view_mode]}" : "svod_#{params[:filters][:view_mode]}"
    end
    if params[:package] and !['unlimited', 'tvod', 'adult_unlimited', 'adult_tvod'].include?(params[:package])
      params[:package] = Moovies.packages.invert[1]
    end
    #unless Moovies.packages.include?(params[:package])
    #  params[:package] = Moovies.packages.invert[1]
    #end
    unless current_customer
      if params[:kind] == :adult
        @discount_top = Discount.find(Moovies.discount["catalogue_adult_#{I18n.locale}"])
      else
        @discount_top = Discount.find(Moovies.discount["catalogue_#{I18n.locale}"])
      end
    end
    @body_id = 'products_index'
    @body_class ='not_reload'
    params[:director_id] = params[:old_director_id] if params[:old_director_id]
    params[:actor_id] = params[:old_actor_id] if params[:old_actor_id]
    if params['actor_id']
      params[:filters] = Hash.new if params[:filters].nil?
      @people = Actor.find(params['actor_id'])
      params['actor_id'] = @people.id
    end
    if params['director_id']
      params[:filters] = Hash.new if params[:filters].nil?
      @people = Director.find(params['director_id'])
      params['director_id'] = @people.id
    end
    
    if params[:package] == Moovies.packages.invert[1]
      @meta_title = t('products.index.unlimited.meta_title')
      @meta_description = t('products.index.unlimited.meta_description')
    elsif params[:package] == Moovies.packages.invert[2]
      @meta_title = t('products.index.tvod.meta_title')
      @meta_description = t('products.index.tvod.meta_description')
    elsif !params[:actor_id].nil?
      @meta_title = t('products.index.actor.meta_title', :name => @people.name)
      @meta_description = t('products.index.actor.meta_description', :name => @people.name)
    elsif !params[:director_id].nil?
      @meta_title = t('products.index.director.meta_title', :name => @people.name)
      @meta_description = t('products.index.director.meta_description', :name => @people.name)
    end
    @source = WishlistSource.wishlist_source(params, @wishlist_source)
    @vod_wishlist = current_customer.products.collect(&:products_id) if current_customer
    @countries = ProductCountry.visible.ordered
      if params[:package].nil? && params[:concerns] != :productable && params[:belgium].blank?
        new_params = session[:sexuality] == 0 ? params.merge(:per_page => 50, :country_id => session[:country_id], :hetero => 1, :includes => ["descriptions_#{I18n.locale}", 'vod_online_be']) : params.merge(:per_page => 50, :country_id => session[:country_id], :includes => ["descriptions_#{I18n.locale}", 'vod_online_be'])
        tvod_package_id = params[:kind] == :adult ? 5 : 2
        svod_package_id = params[:kind] == :adult ? 4 : 1
        @tvod_last =        Product.filter(nil, new_params.merge(:view_mode => 'tvod_last_added',  :package => Moovies.packages.invert[tvod_package_id]))
        @tvod_soon =        Product.filter(nil, new_params.merge(:view_mode => 'tvod_soon', :without_series =>1, :package => Moovies.packages.invert[tvod_package_id]))

        @tvod_best_rating = Product.filter(nil, new_params.merge(:view_mode => 'tvod_best_rated',  :package => Moovies.packages.invert[tvod_package_id]))
        @tvod_most_view =   Product.filter(nil, new_params.merge(:view_mode => 'tvod_most_viewed', :package => Moovies.packages.invert[tvod_package_id]))
        @tvod_last_chance = Product.filter(nil, new_params.merge(:view_mode => 'tvod_last_chance', :package => Moovies.packages.invert[tvod_package_id]))
        @svod_last =        Product.filter(nil, new_params.merge(:view_mode => 'svod_last_added',  :package => Moovies.packages.invert[svod_package_id]))
        @svod_best_rating = Product.filter(nil, new_params.merge(:view_mode => 'svod_best_rated',  :package => Moovies.packages.invert[svod_package_id]))
        @svod_most_view =   Product.filter(nil, new_params.merge(:view_mode => 'svod_most_viewed', :package => Moovies.packages.invert[svod_package_id]))
        #@svod_last_chance = Product.filter(nil, new_params.merge(:view_mode => 'svod_last_chance', :package => Moovies.packages.invert[params[:kind] == :adult ? 4 : 1]))
        @top = Product.joins(:lists).includes("descriptions_#{I18n.locale}", 'vod_online_be').where("lists.#{I18n.locale} = 1").order("lists.id desc").limit(25)
      else
        new_params = params.merge(:per_page => 25, :country_id => session[:country_id], :includes => [ "descriptions_#{I18n.locale}", 'vod_online_be'])
        new_params = new_params.merge(:hetero => 1) if session[:sexuality] == 0
        @products = Product.filter_online(nil, new_params)
        if params[:filters]
          @selected_countries = ProductCountry.where(:countries_id => params[:filters][:country_id]) 
          @languages = Language.by_language(I18n.locale).find(params[:filters][:audio].reject(&:empty?)).collect(&:name).join(', ') if Product.audio?(params[:filters][:audio])
          @subtitles = Subtitle.by_language(I18n.locale).find(params[:filters][:subtitles].reject(&:empty?)).collect(&:name).join(', ') if Product.subtitle?(params[:filters][:subtitles])
        end
      end
    #else
    #  
    #  @filter = view_context.get_current_filter({})
    #  new_params = session[:sexuality] == 0 ? params.merge(:per_page => 15, :country_id => session[:country_id], :hetero => 1) : params.merge(:per_page => 15, :country_id => session[:country_id])
    #  @products = Product.filter(@filter, new_params)
    #end
    @target = cookies[:endless] == 'deactive' ?  '_self' : '_blank'
    @carousels = Landing.hit.by_language(I18n.locale).not_expirated
    
    if params[:endless]
      cookies.permanent[:endless] = params[:endless]
    end
    if params[:display]
      cookies.permanent[:display] = params[:display]
    end
    @rating_color = params[:kind] == :adult ? :pink : :white
    if request.xhr?
      render :layout => false
    end
      
  end

  def detect_facebook_post!
    if request.env['facebook.params']
      logger.info "Received POST w/ signed_request from Facebook."
      log_in_with_facebook request.env['facebook.params']
    end
    true
  end

  def redirect_to_auth_facebook!
    redirect_to '/auth/facebook'
  end

  def log_in_with_facebook(auth_hash)
    if auth_hash['uid'] || auth_hash['user_id']
      logger.info "Logging in with Facebook..."
      if get_session[:user].nil? || (auth_hash['uid'] || auth_hash['user_id']).try(:to_i) != get_session[:user][:uid]
        logger.info "Logging in user #{auth_hash['uid'] || auth_hash['user_id']}"

        # In real life, you'd perform some real authentication here
        u = {}
        u[:uid]              = (auth_hash['uid'] || auth_hash['user_id']).to_i
        u[:token]            = auth_hash.value_at_path 'credentials', 'token'
        u[:token_expires_at] = Time.at(auth_hash.value_at_path('credentials', 'expires_at').to_i)
        u[:logged_in_at]     = Time.now
        session[:user] = u
      end
      true
    else
      logger.info "Tried to login with Facebook. :uid was not specified. Aborting."
      log_out
      false
    end
  end

  def logged_in?
    !! get_session[:user]
  end

  def log_out
    session[:user] = nil
  end

  # Get the session. If it's present in the header, this has precedence over the regular cookie session.
  def get_session
    if has_session_in_header?
      logger.info "Reading session from header"
      return @header_session if @header_session
      encrypted_session = request.headers['X-Session']
      secret = FBCanvasRails::Application.config.secret_token
      verifier = ActiveSupport::MessageVerifier.new(secret, 'SHA1')
      @header_session = verifier.verify(encrypted_session).with_indifferent_access
    else
      logger.info "Reading session from cookies"
      session
    end
  end

private
  def find_product
    if !params[:recommendation].nil?
      @source = params[:recommendation]
    elsif params[:source]
      @source = params[:source]
    else
      @source = @wishlist_source[:elsewhere]
    end
    begin
      if params[:id]
        id = params[:id]
      elsif params[:old_product_id]
        id = params[:old_product_id]
      else
        id = params[:product_id]
      end
      if Rails.env == "production"
        if params[:kind] == :adult
          @product = Product.adult_available.find(id)
          @rating_color = :pink
        else
          @product = Product.normal_available.find(id)
          @rating_color = :white
        end
      else
        if params[:kind] == :adult
          @product = Product.find(id)
          @rating_color = :pink
        else
          @product = Product.find(id)
          @rating_color = :white
        end
      end
    rescue ActiveRecord::RecordNotFound
      msg = "product not found"
      logger.error(msg)
      flash[:notice] = msg
      redirect_to products_short_path
    end
  end

  def has_session_in_header?
    !!(request.headers['X-Session'])
  end
end