class ProductsController < ApplicationController

  before_filter :find_product, :except => [:index, :drop_cached]

  layout "responsive"

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

  def show
    @body_id = "film-details"
    unless current_customer
      if params[:kind] == :adult
        @discount_top = Discount.find(Moovies.discount["catalogue_show_#{I18n.locale}_adult"])
      else
        @discount_top = Discount.find(Moovies.discount["catalogue_show_#{I18n.locale}"])
      end
    end
    #to do user_agent = UserAgent.parse(request.user_agent)
    @countries = ProductCountry.visible.order
    @svod_date = @product.svod_dates.current.order.first
    #@filter = get_current_filter({})
    unless request.xhr?
      @trailer =  @product.trailer?
      data = @product.description_data(true)
      @product_title = @product.series? ? @product.serie.name : data[:title]
      @product_image = data[:image]
      @product_description =  data[:description]
      @categories = @product.categories
      @token = current_customer ? current_customer.get_token(@product.imdb_id, @product.season_id, @product.episode_id) : nil
    end

    @meta_title = t('products.show.meta_title', :name => @product_title, :default => '')
    @meta_description = t('products.show.meta_description', :name => @product_title, :default => '')

    @response_id = params[:response_id]

    if !request.xhr? || (request.xhr? && (params[:reviews_page] || params[:sort]))
      reviews_data = view_context.get_reviews()
      @reviews = reviews_data[:reviews]
      @review_sort = reviews_data[:review_sort]
      @reviews_count = @reviews.total_entries
    end

    if request.xhr?
      if params[:reviews_page] || params[:sort]
        render :partial => 'products/show/reviews', :locals => {:product => @product, :reviews_count => @reviews_count, :reviews => @reviews, :review_sort => @review_sort, :source => @source, :response_id => @source}
      elsif params[:recommendation_page]
        render :partial => 'products/show/recommendations', :locals => { :rating_color => @rating_color, :recommendation_nb_page => @recommendation_nb_page, :recommendation_page => @recommendation_page, :products => @recommendations, :recommendation_response_id => @recommendation_response_id}
      end
    else
      #if  params[:response_id]
      #  Customer.send_evidence('RecClick', @product.to_param, current_customer, request, {:response_id => params[:response_id], :segment1 => @source, :formFactor => view_context.format_text(@browser), :rule => @source})
      #end
      #Customer.send_evidence('ViewItemPage', @product.to_param, current_customer, request, {:response_id => params[:response_id], :segment1 => @source, :formFactor => view_context.format_text(@browser), :rule => @source})
    end
  end

  def uninterested
    unless current_customer.rated_products.include?(@product) || current_customer.seen_products.include?(@product) || current_customer.uninterested_products.include?(@product)
      delimiter_present = params[:delimiter_present] || 0
      delimiter_present = delimiter_present.to_i
      @product.uninterested_customers << current_customer
      Customer.send_evidence('NotInterestedItem', @product.to_param, current_customer, request, {:response_id => params[:response_id], :segment1 => @source, :formFactor => view_context.format_text(@browser), :rule => @source})
      #expiration_recommendation_cache()
    end
    if request.xhr?
      render :partial => 'products/show/seen_uninterested', :locals => {:product => @product, :delimiter_present => delimiter_present, :source => @source, :response_id => params[:response_id]}
    else
      redirect_to product_path(:id => @product.to_param, :source => @source)
    end
  end

  def seen
    @product.seen_customers << current_customer
    delimiter_present = params[:delimiter_present] || 0
    delimiter_present = delimiter_present.to_i
    Customer.send_evidence('AlreadySeen', @product.to_param, current_customer, request, {:response_id => params[:response_id], :segment1 => @source, :formFactor => view_context.format_text(@browser), :rule => @source})
    #expiration_recommendation_cache()
    if request.xhr?
      render :partial => 'products/show/seen_uninterested', :locals => {:product => @product, :delimiter_present => delimiter_present, :source => @source, :response_id => params[:response_id]}
    else
      redirect_to product_path(:id => @product.to_param, :source => @source)
    end
  end

  def awards
    data = @product.description_data(true)
    @product_description =  data[:description]
    respond_to do |format|
      format.js {render :partial => 'products/show/awards', :locals => {:product => @product, :size => 'full'}}
    end
  end

  def trailer
    if params[:streamin_trailer_id]
      trailers = Rails.env == "production" ? @product.streaming_trailers.available : @product.streaming_trailers.available_beta
      trailer = StreamingTrailer.find(params[:streamin_trailer_id])
    elsif @product.trailer?
      trailers = Rails.env == "production" ? @product.streaming_trailers.available : @product.streaming_trailers.available_beta
      trailer = StreamingTrailer.get_best_version(@product.imdb_id, I18n.locale)
    else
        trailers = @product.trailers.by_language(I18n.locale).paginate(:per_page => 1, :page => params[:trailer_page])
    end
    if request.xhr?
      if trailer.class.name == 'StreamingTrailer'
        render :partial => 'products/trailer', :locals => {:trailer => trailer, :trailers => trailers}
      elsif trailers.first
        render :partial => 'products/trailer', :locals => {:trailer => trailers.first, :trailers => trailers}
      else
        render :text => 'error'
      end
    else
      @trailer = trailers
      if trailers.first && trailers.first.url
        redirect_to trailers.first.url
      else
        redirect_to product_path(:id => @product.to_param, :source => @source)
      end
    end
  end

  def drop_cached
    expire_fragment ("/fr/products/product2_1_1_#{params[:product_id]}")
    expire_fragment ("/nl/products/product2_1_1_#{params[:product_id]}")
    expire_fragment ("/en/products/product2_1_1_#{params[:product_id]}")
    expire_fragment ("/fr/products/product2_1_0_#{params[:product_id]}")
    expire_fragment ("/nl/products/product2_1_0_#{params[:product_id]}")
    expire_fragment ("/en/products/product2_1_0_#{params[:product_id]}")
    expire_fragment ("/fr/products/product2_0_1_#{params[:product_id]}")
    expire_fragment ("/nl/products/product2_0_1_#{params[:product_id]}")
    expire_fragment ("/en/products/product2_0_1_#{params[:product_id]}")
    expire_fragment ("/fr/products/product2_0_0_#{params[:product_id]}")
    expire_fragment ("/nl/products/product2_0_0_#{params[:product_id]}")
    expire_fragment ("/en/products/product2_0_0_#{params[:product_id]}")
    render :nothing => true
  end

  def step
    data = @product.description_data(true)
    @product_title = data[:title]
    @product_image = data[:image]
    @product_description =  data[:description]
  end

  def sign_up
    if request.xhr?
      render :layout => false
    end
  end

  def action
    @source = params[:source] || 7
    @streaming = StreamingProduct.available.country(Product.country_short_name(session[:country_id])).by_primary(@product.imdb_id, @product.season_id, @product.episode_id).first
    if request.xhr?
      render :layout => false
    end
  end

  def data
    @source = params[:source].nil? ? 7 : params[:source]
    if request.xhr?
      render :layout => false
    end
  end

  def log
    if request.xhr?
      render :layout => false
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
end
