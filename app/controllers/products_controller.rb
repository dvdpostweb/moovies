class ProductsController < ApplicationController

  before_filter :find_product, :only => [:uninterested, :seen, :awards, :trailer, :show, :step]

  def index
    @body_id = 'products_index'
    @filter = view_context.get_current_filter({})
    if params['actor_id']
      @actor = Actor.find(params['actor_id'])
      params['actor_id'] = @actor.id
    end
    if params['director_id']
      @director = Director.find(params['director_id'])
      params['director_id'] = @director.id
    end
    new_params = session[:sexuality] == 0 ? params.merge(:per_page => 20, :country_id => session[:country_id], :hetero => 1) : params.merge(:per_page => 20, :country_id => session[:country_id])
    
    @products = Product.filter(@filter, new_params)
    @target = cookies[:endless] == 'active' ? '_blank' : '_self'
    if params[:endless]
      cookies.permanent[:endless] = params[:endless]
    end
    #if params[:search] == t('products.left_column.search')
    #  params.delete(:search)
    #else
    #  if params[:search]
    #    sub_str = params[:search].to_s
    #    params[:search] = sub_str.gsub(/\//,'').gsub(/"/,' ').gsub(/\(/,' ').gsub(/\)/,' ')
    #  end
    #end
    @tokens = current_customer.get_all_tokens_id(params[:kind]) if current_customer
    #
    #if params[:category_id]
    #  filter = get_current_filter
    #  if params[:category_id] && streaming_access? && (params[:view_mode] != "streaming" && params[:filter] != "vod")
    #    if current_customer
    #      @popular = current_customer.streaming(filter, {:category_id => params[:category_id], :country_id => session[:country_id]}).paginate(:per_page => 6, :page => params[:popular_streaming_page])
    #      @papular_page = params[:popular_streaming_page] || 1
    #      @papular_nb_page = @popular.total_pages
    #    else
    #      @popular = nil
    #    end
    #  else
    #    @popular = nil
    #  end      
    #  if params[:category_id].to_i == 76 && current_customer
    #    current_customer.customer_attribute.update_attribute(:sexuality, 1)
    #    session[:sexuality] = 1
    #  end
    #end
    #if params[:sort].nil?
    #  params[:sort] = 'normal'
    #end
    #@rating_color = params[:kind] == :adult ? :pink : :white
    #@countries = ProductCountry.visible.order
    #@collections = Category.by_size.random
    ##unless request.format.js?
    #  item_per_page =  20
    #  if params[:search] && !params[:search].empty?
    #    @exact_products = Product.filter(@filter, params.merge(:exact => 1, :countr_id => session[:country_id]))
    #    @directors_count = params[:kind] == :normal ?  Director.search_clean(params[:search], 0, true) : 0
    #    @actors_count = Actor.search_clean(params[:search], params[:kind], 0, true)
    #    kind = params[:kind]
    #    Search.create(:name => params[:search], :kind => DVDPost.search_kinds[kind])
    #  end
    #  
    #  if session[:sexuality] == 0
    #    new_params = params.merge(:hetero => 1) 
    #  else
    #    new_params = params
    #  end
    #  new_params = new_params.merge(:per_page => item_per_page, :country_id => session[:country_id])
    #  @products = 
    #  if params[:view_mode] == 'recommended'
    #    if(session[:sort] != params[:sort])
    #      expiration_recommendation_cache()
    #    end
    #    session[:sort]=params[:sort] 
    #    retrieve_recommendations(params[:page], params.merge(:per_page => item_per_page, :kind => params[:kind], :language => DVDPost.product_languages[I18n.locale.to_s]))
    #  else
    #    
    #    if @exact_products && @exact_products.size > 0
    #      Product.filter(@filter, new_params, @exact_products)
    #    else
    #      Product.filter(@filter, new_params)
    #    end
    #  end
    #  @products_count = @products ? @products.count : 0
    #  if params[:search] && !params[:search].empty?
    #    if params[:type].nil? &&  @products_count == 0 && @exact_products.count == 0
    #      if @actors_count > 0
    #        params[:type] = 'actors'
    #      elsif @directors_count > 0
    #         params[:type] = 'directors'
    #      end 
    #    end
    #    if params[:type] == 'actors'
    #      @actors = Actor.search_clean(params[:search], params[:kind], params[:actors_page], false)
    #    elsif params[:type] == 'directors'
    #      @directors = Director.search_clean(params[:search], params[:directors_page], false)
    #    end
    #  end
    #  
    #  @jacket_mode = Product.get_jacket_mode(params)
    ##end
    #respond_to do |format|
    #  format.html
    #  format.js {
    #    if params[:popular_streaming_page]
    #      render :partial => 'products/index/streaming', :locals => {:products => @popular, :product_page => @papular_page, :product_nb_page => @papular_nb_page}
    #    elsif params[:recommendation_page]
    #      render :partial => 'home/index/recommendations', :locals => {:products => retrieve_recommendations(params[:recommendation_page], {:per_page => 8, :kind => params[:kind], :language => DVDPost.product_languages[I18n.locale.to_s]})}  
    #    end
    #  
    #  }
    #end  
  end

  def show
    @body_id = "film-details"
    #to do user_agent = UserAgent.parse(request.user_agent)
    @tokens = current_customer.get_all_tokens_id(params[:kind], @product.imdb_id) if current_customer
    #to do @filter = get_current_filter({})
    unless request.xhr?
      @trailer =  @product.trailer?
      data = @product.description_data(true)
      @product_title = data[:title]
      @product_image = data[:image]
      @product_description =  data[:description]
      @categories = @product.categories
      @token = current_customer ? current_customer.get_token(@product.imdb_id) : nil
    end
    @response_id = params[:response_id]
    
    if !request.xhr? || (request.xhr? && (params[:reviews_page] || params[:sort]))
      reviews_data = view_context.get_reviews()
      @reviews = reviews_data[:reviews]
      @review_sort = reviews_data[:review_sort]
      @reviews_count = @reviews.total_entries
    end

    if !request.xhr? || (request.xhr? && params[:recommendation_page])
      #product_recommendations = @product.recommendations(params[:kind])
      customer_id = current_customer ? current_customer.id : 0
      r_type = params[:r_type].to_i || 1
      @recommendation_page = params[:recommendation_page].to_i
      @recommendation_page = 1 if @recommendation_page == 0
      data = @product.recommendations(params[:kind])
      if data
        product_recommendations = data[:products]
        @recommendation_response_id = data[:response_id]
      else
        product_recommendations = nil
      end
      if product_recommendations
      @recommendations = product_recommendations.paginate(:page => params[:recommendation_page], :per_page => 5)
      @recommendation_nb_page = @recommendations.total_pages
      end
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
    elsif @product.trailer_streaming?
      trailers = Rails.env == "production" ? @product.streaming_trailers.available : @product.streaming_trailers.available_beta
      trailer = StreamingTrailer.get_best_version(@product.imdb_id, I18n.locale)
    else
        trailers = @product.trailers.by_language(I18n.locale).paginate(:per_page => 1, :page => params[:trailer_page])
    end
    Customer.send_evidence('ViewTrailer', @product.to_param, current_customer, request, {:response_id => params[:response_id], :segment1 => @source, :formFactor => view_context.format_text(@browser), :rule => @source})
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
      elsif trailers.first
        if 1==0 #to do mobile_request?
            render :partial => 'products/trailer', :locals => {:trailer => trailers.first, :trailers => trailers}, :layout => 'application'
        end
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
      redirect_to products_path
    end
  end
end