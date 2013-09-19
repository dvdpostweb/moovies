#encoding: utf-8

class ReviewsController < ApplicationController

  def index
    if params[:sort]
      sort = Review.sort[params[:sort].to_sym]
    else
      sort = Review.sort[:date]
    end
    @reviews = Review.by_customer_id(params[:customer_id]).approved.ordered("#{sort} DESC, (customers_best_rating - customers_bad_rating ) DESC, customers_best_rating DESC").joins(:product).where(:products => {:products_type => Moovies.product_kinds[params[:kind]], :products_status => [-2,0,1]}).paginate(:page => params[:page], :per_page => 10)
    @reviews_count =  @reviews.total_entries
    
    @customer = Customer.find(params[:customer_id])
    @source = @wishlist_source[:reviews]
    if request.xhr?
      render :layout => false
    end
  end

  def show
    @review = Review.find(params[:id])
    if request.xhr?
      render :layout => false
    end
  end

  def new
    @product = Product.both_available.find(params[:product_id])
    @review = Review.new(:imdb_id => @product.imdb_id)
    if request.xhr?
      render :layout => false
    end
  end

  def create
    #begin
      @product = Product.both_available.find(params[:product_id])
      params[:review][:text] = params[:review][:text].gsub(/\n/, '').gsub(/\r/, '').gsub(//, "'").gsub(//,'"').gsub(//,'"').gsub(//,'...').gsub(//,'&oelig;').gsub(/«/,'"').gsub(/»/,'"')
      review = @product.reviews.build(params[:review])
      review.customer = current_customer
      review.customers_name = current_customer.nickname
      review.languages_id = Moovies.languages[I18n.locale]
      Rails.logger.debug { "@@@#{review.inspect}" }
      review.save!
      unless current_customer.has_rated?(@product)
        @product.ratings.create(:customer => current_customer, :value => params[:review][:rating])
        current_customer.seen_products << @product
        Customer.send_evidence('Rating', params[:product_id], current_customer, request.remote_ip, {:rating => params[:review][:rating]})
      end
      flash[:notice] = t('products.show.review.review_save')
    
    #rescue Exception => e  
    #  flash[:error] = t('products.show.review.review_not_save')
    #end
    if request.xhr?
      render :layout => false
    else
      redirect_to product_path(:id => @product.to_param, :source => params[:source])
    end
  end
end
