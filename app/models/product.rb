class Product < ActiveRecord::Base
  include ThinkingSphinx::Scopes
  cattr_reader :per_page
  @@per_page = 20
  self.primary_key = :products_id
  
  alias_attribute :availability,    :products_availability
  alias_attribute :available_at,    :products_date_available
  alias_attribute :created_at,      :products_date_added
  alias_attribute :kind,            :products_type
  alias_attribute :media,           :products_media
  alias_attribute :original_title,  :products_title
  alias_attribute :product_type,    :products_product_type
  alias_attribute :rating,          :products_rating
  alias_attribute :runtime,         :products_runtime
  alias_attribute :series_id,       :products_series_id
  alias_attribute :year,            :products_year
  alias_attribute :price,           :products_price
  alias_attribute :next,            :products_next
  alias_attribute :studio,          :products_studio
  alias_attribute :qty_sale,        :quantity_to_sale
  alias_attribute :price_sale,      :products_sale_price
  
  belongs_to :director, :foreign_key => :products_directors_id
  belongs_to :studio, :foreign_key => :products_studio
  belongs_to :country, :class_name => 'ProductCountry', :foreign_key => :products_countries_id
  belongs_to :picture_format, :foreign_key => :products_picture_format, :conditions => {:language_id => Moovies.languages[I18n.locale.to_s]}
  has_one :public, :primary_key => :products_public, :foreign_key => :public_id, :conditions => {:language_id => Moovies.languages[I18n.locale.to_s]}
  has_many :descriptions, :class_name => 'ProductDescription', :foreign_key => :products_id
  has_many :ratings, :foreign_key => :products_id
  has_many :reviews, :foreign_key => :products_id
  has_many :uninteresteds, :foreign_key => :products_id
  has_many :uninterested_customers, :through => :uninteresteds, :source => :customer, :uniq => true
  has_many :streaming_products, :foreign_key => :imdb_id, :primary_key => :imdb_id, :conditions => {:available => 1}
  has_many :tokens, :foreign_key => :imdb_id, :primary_key => :imdb_id
  has_many :streaming_trailers, :foreign_key => :imdb_id, :primary_key => :imdb_id
  has_many :tokens_trailers, :foreign_key => :imdb_id, :primary_key => :imdb_id
  
  #has_many :recommendations
  has_many :recommendations_products, :through => :recommendations, :source => :product
  has_and_belongs_to_many :actors, :join_table => :products_to_actors, :foreign_key => :products_id, :association_foreign_key => :actors_id
  has_and_belongs_to_many :categories, :join_table => :products_to_categories, :foreign_key => :products_id, :association_foreign_key => :categories_id
  has_and_belongs_to_many :collections, :join_table => :products_to_themes, :foreign_key => :products_id, :association_foreign_key => :themes_id
  has_and_belongs_to_many :product_lists, :join_table => :listed_products, :order => 'listed_products.order asc'
  has_and_belongs_to_many :soundtracks, :join_table => :products_to_soundtracks, :foreign_key => :products_id, :association_foreign_key => :products_soundtracks_id
  has_and_belongs_to_many :seen_customers, :class_name => 'Customer', :join_table => :products_seen, :uniq => true
  
  scope :normal_available, where('products_status != -1 and products_type = ? ', Moovies.product_kinds[:normal])
  scope :adult_available, where('products_status != -1 and products_type = ? ', Moovies.product_kinds[:adult])
  scope :both_available, where('products_status != -1')
  scope :by_imdb_ids, lambda {|imdb| where("imdb_id in (#{imdb})")}
  scope :ordered, :order => 'products_id desc'
  scope :group_by_imdb, :group => 'imdb_id'
  sphinx_scope(:by_products_id)           {|products_id|      {:with =>       {:id => products_id}}}
  sphinx_scope(:exclude_products_id)      {|products_id|      {:without =>    {:id => products_id}}}
  sphinx_scope(:by_actor)                 {|actor|            {:with =>       {:actors_id => actor.to_param}}}
  sphinx_scope(:by_audience)              {|min, max|         {:with =>       {:audience => Public.legacy_age_ids(min, max)}}}
  sphinx_scope(:by_category)              {|category|         {:with =>       {:category_id => category.to_param}}}
  sphinx_scope(:by_collection)            {|collection|       {:with =>       {:collection_id => collection.to_param}}}
  sphinx_scope(:hetero)                   {{:without =>       {:category_id => [76, 72]}}}
  sphinx_scope(:gay)                      {{:with =>          {:category_id => [76, 72]}}}
  sphinx_scope(:by_country)               {|country|          {:with =>       {:country_id => country.to_param}}}
  sphinx_scope(:by_director)              {|director|         {:with =>       {:director_id => director.to_param}}}
  sphinx_scope(:by_studio)                {|studio|           {:with =>       {:studio_id => studio.to_param}}}
  sphinx_scope(:by_streaming_studio)      {|studio|           {:with =>       {:streaming_studio_id => studio.to_param}}}
  sphinx_scope(:by_imdb_id)               {|imdb_id|          {:with =>       {:imdb_id => imdb_id}}}
  sphinx_scope(:by_language)              {|language|         {:order =>      language.to_s == 'fr' ? :french : :dutch, :sort_mode => :desc}}
  sphinx_scope(:by_kind)                  {|kind|             {:conditions => {:products_type => Moovies.product_kinds[kind]}}}
  sphinx_scope(:by_media)                 {|media|            {:conditions => {:products_media => media}}}
  sphinx_scope(:by_special_media_be)      {|media|            {:with =>       {:special_media_be => media}}}
  sphinx_scope(:by_special_media_lu)      {|media|            {:with =>       {:special_media_lu => media}}}
  sphinx_scope(:by_special_media_nl)      {|media|            {:with =>       {:special_media_nl => media}}}
  sphinx_scope(:remove_wrong_be)          {|media|            {:without =>    {:special_media_be => media}}}
  sphinx_scope(:remove_wrong_lu)          {|media|            {:without =>    {:special_media_lu => media}}}
  sphinx_scope(:remove_wrong_nl)          {|media|            {:without =>    {:special_media_nl => media}}}
  sphinx_scope(:by_period)                {|min, max|         {:with =>       {:year => min..max}}}
  sphinx_scope(:by_products_list)         {|product_list|     {:with =>       {:products_list_ids => product_list.to_param}}}
  sphinx_scope(:by_ratings)               {|min, max|         {:with =>       {:rating => min..max}}}
  sphinx_scope(:by_recommended_ids)       {|recommended_ids|  {:with =>       {:id => recommended_ids}}}
  sphinx_scope(:with_languages)           {|language_ids|     {:with =>       {:language_ids => language_ids}}}
  sphinx_scope(:with_subtitles)           {|subtitle_ids|     {:with =>       {:subtitle_ids => subtitle_ids}}}
  sphinx_scope(:with_speaker)             {|speaker_ids|      {:with =>       {:speaker => speaker_ids}}}
  sphinx_scope(:available)                {{:without =>       {:status => [99]}}}
  sphinx_scope(:dvdpost_choice)           {{:with =>          {:dvdpost_choice => 1}}}
  sphinx_scope(:recent)                   {{:without =>       {:availability => 0}, :with => {:available_at => 2.months.ago..Time.now.end_of_day, :next => 0}}}
  sphinx_scope(:new_vod)                  {|country|          {:conditions =>    {:new_vod => country}}}
  sphinx_scope(:cinema)                   {{:with =>          {:in_cinema_now => 1, :next => 1}}}
  sphinx_scope(:soon)                     {{:with =>          {:in_cinema_now => 0, :next => 1}}}
  sphinx_scope(:dvd_soon)                 {{:with =>          {:in_cinema_now => 0, :next => 1}}}
  sphinx_scope(:vod_soon)                 {{:with =>          {:vod_next => 1}}}
  sphinx_scope(:not_soon)                 {{:with =>          {:vod_next => 0}}}
  sphinx_scope(:vod_soon_lux)             {{:with =>          {:vod_next_lux => 1}}}
  sphinx_scope(:not_soon_lux)             {{:with =>          {:vod_next_lux => 0}}}
  sphinx_scope(:vod_soon_nl)              {{:with =>          {:vod_next_nl => 1}}}
  sphinx_scope(:not_soon_nl)              {{:with =>          {:vod_next_nl => 0}}}
  sphinx_scope(:streaming)                {|country|          {:without =>       {:streaming_imdb_id => 0}, :country => {:streaming_available => country}}}
  sphinx_scope(:random)                   {{:order =>         '@random'}}
  sphinx_scope(:popular_new)              {{:with =>          {:popular => 1}}}
  sphinx_scope(:highlight_best_fr)        {{:with =>          {:highlight_best_fr => 1..100}}}
  sphinx_scope(:highlight_best_nl)        {{:with =>          {:highlight_best_nl => 1..100}}}
  sphinx_scope(:highlight_best_en)        {{:with =>          {:highlight_best_en => 1..100}}}
  sphinx_scope(:highlight_best_vod_be_fr) {{:with =>          {:highlight_best_vod_be_fr => 1..100}}}
  sphinx_scope(:highlight_best_vod_be_nl) {{:with =>          {:highlight_best_vod_be_nl => 1..100}}}
  sphinx_scope(:highlight_best_vod_be_en) {{:with =>          {:highlight_best_vod_be_en => 1..100}}}
  sphinx_scope(:highlight_best_vod_lu_fr) {{:with =>          {:highlight_best_vod_lu_fr => 1..100}}}
  sphinx_scope(:highlight_best_vod_lu_nl) {{:with =>          {:highlight_best_vod_lu_nl => 1..100}}}
  sphinx_scope(:highlight_best_vod_lu_en) {{:with =>          {:highlight_best_vod_lu_en => 1..100}}}
  sphinx_scope(:highlight_best_vod_nl_fr) {{:with =>          {:highlight_best_vod_nl_fr => 1..100}}}
  sphinx_scope(:highlight_best_vod_nl_nl) {{:with =>          {:highlight_best_vod_nl_nl => 1..100}}}
  sphinx_scope(:highlight_best_vod_nl_en) {{:with =>          {:highlight_best_vod_nl_en => 1..100}}}
  sphinx_scope(:popular)                  {{:with =>          {:available_at => 8.months.ago..2.months.ago, :rating => 3.0..5.0, :series_id => 0, :in_stock => 3..1000}}}
  sphinx_scope(:not_recent)               {{:with =>          {:next => 0}}}
  sphinx_scope(:by_serie)                 {|serie_id|         {:with => {:series_id => serie_id}}}
  sphinx_scope(:ppv)                      {{:with =>          {:is_ppv => 1}}}
  sphinx_scope(:by_new)                   {{:with =>          {:year => 2.years.ago.year..Date.today.year, :next => 0, :available_at => 3.months.ago..Time.now.end_of_day}}}
  sphinx_scope(:order)                    {|order, sort_mode| {:order => order, :sort_mode => sort_mode}}
  sphinx_scope(:group)                    {|group,sort|       {:group_by => group, :group_function => :attr, :group_clause   => sort}}
                                          
  sphinx_scope(:limit)                    {|limit|            {:limit => limit}}

  def self.list_sort
     sort = OrderedHash.new
     sort.push(:normal, 'normal')
     sort.push(:alpha_az, 'alpha_az')
     sort.push(:alpha_za, 'alpha_za')
     sort.push(:rating, 'rating')
     sort.push(:most_viewed, 'most_viewed')
     sort.push(:most_viewed_last_year, 'most_viewed_last_year')
     sort.push(:new, 'new')
     
     sort
  end
  
  def self.filter(filter, options={}, exact=nil)
    Rails.logger.debug { "@@@#{options.inspect}" }
    if options[:exact]
      products = search_clean_exact(options[:search], {:page => options[:page], :per_page => options[:per_page], :limit => options[:limit]})
    else
      products = search_clean(options[:search], {:page => options[:page], :per_page => options[:per_page], :limit => options[:limit]})
    end
    #products = products.exclude_products_id([exact.collect(&:products_id)]) if exact
    #products = products.by_products_list(options[:list_id]) if options[:list_id] && !options[:list_id].blank?
    products = products.by_actor(options[:actor_id]) if options[:actor_id]
    #products = products.by_category(options[:category_id]) if options[:category_id]
    #products = products.by_collection(options[:collection_id]) if options[:collection_id]
    #products = products.hetero if options[:hetero] && (options[:category_id] && (options[:category_id].to_i != 76 && options[:category_id].to_i != 72) )
    #products = products.by_director(options[:director_id]) if options[:director_id]
    #products = products.by_imdb_id(options[:imdb_id]) if options[:imdb_id]
    #
    #if options[:studio_id]
    #  if options[:filter] == "vod" && options[:kind] == :normal
    #    products = products.by_streaming_studio(options[:studio_id]) 
    #  else
    #    products = products.by_studio(options[:studio_id]) 
    #  end
    #end
    #products = products.by_audience(filter.audience_min, filter.audience_max) if filter.audience? && options[:kind] == :normal
    #products = products.by_country(filter.country_id) if filter.country_id?
    #products = products.by_special_media([2,4,5]) if options[:filter] && options[:filter] == "vod"
    #products = products.by_special_media([1,2]) if options[:filter] && options[:filter] == "dvd"
    #products = products.by_special_media([3,4,7]) if options[:filter] && options[:filter] == "bluray"
    #products = products.by_special_media([6,7]) if options[:filter] && options[:filter] == "bluray3d"
    #
    #if filter.media? && options[:kind] == :normal && options[:view_mode] != "streaming" && options[:filter] != "vod"
    #  
    #  medias = filter.media.dup
    #  media_i = Array.new
    #  if medias.include?(:dvd)
    #    if medias.include?(:bluray)
    #      if medias.include?(:streaming)
    #        media_i = [1,2,3,4,5,7]
    #      else
    #        media_i = [1,2,3,4,7]
    #      end
    #    elsif medias.include?(:streaming)
    #      media_i = [1,2,5]
    #    else
    #      media_i = [1,2]
    #    end
    #  elsif medias.include?(:bluray)
    #    if medias.include?(:streaming)
    #      media_i = [2,3,4,5,7]
    #    else
    #      media_i = [3,4,7]
    #    end
    #  elsif medias.include?(:streaming)
    #    media_i = [2,4,5,7]
    #  end
    #  if medias.include?(:bluray3d)
    #    media_i.push([6,7])
    #  end
    #  products = products.by_special_media(media_i)
    #end
    #products = products.by_ratings(filter.rating_min.to_f, filter.rating_max.to_f) if filter.rating?
    #products = products.by_period(filter.year_min, filter.year_max) if filter.year?
    #if filter.audio?
    #  products = products.with_languages(filter.audio)
    #else
    #  products = products.with_languages(options[:audio]) if options[:audio] 
    #end
    #if filter.subtitles?
    #  products = products.with_subtitles(filter.subtitles) 
    #else
    #  products = products.with_subtitles(options[:subtitles]) if options[:subtitles] 
    #end
    #products = products.dvdpost_choice if filter.dvdpost_choice?
    #if options[:not_soon]
    #  products = products.not_soon 
    #end
    #if options[:view_mode]
    #  products = case options[:view_mode].to_sym
    #  when :recent
    #    products.recent
    #  when :vod_recent
    #    products.new_vod
    #  when :soon
    #    products.soon
    #  when :vod_soon
    #    products.vod_soon
    #  when :cinema
    #    products.cinema
    #  when :streaming
    #    products = products.by_special_media([2,4,5])
    #  when :weekly_streaming
    #    products.weekly_streaming
    #  when :popular_streaming
    #      products.streaming.limit(10)
    #  when :recommended
    #    recom = products.by_recommended_ids(filter.recommended_ids).with_speaker(options[:language]).limit(50)
    #    recom
    #  when :popular
    #    products.popular_new.limit(800)
    #  else
    #    products
    #  end
    #end
    #if options[:sort] && options[:sort].to_sym == :new
    #  products = products.not_recent
    #end
    #if options[:kind] == :adult
    #  products = products.by_kind(:adult).available
    #else
    #  products = products.by_kind(:normal).available
    #end
    #
    #if options[:list_id] && !options[:list_id].blank?
    #  sort = sort_by("special_order asc", options)
    #elsif options[:search] && !options[:search].blank?
    #  sort = sort_by("default_order desc, in_stock DESC", options)
    #elsif options[:view_mode] && options[:view_mode].to_sym == :streaming
    #  sort = sort_by("streaming_id desc", options)
    #elsif options[:view_mode] && options[:view_mode].to_sym == :vod_recent
    #  sort = sort_by("available_order desc", options)
    #elsif options[:view_mode] && options[:view_mode].to_sym == :vod_soon
    #  sort = sort_by("streaming_id desc", options)
    #elsif options[:view_mode] && options[:view_mode].to_sym == :popular_streaming
    #  sort = sort_by("count_tokens desc, streaming_id desc", options)
    #elsif options[:view_mode] && options[:view_mode].to_sym == :popular
    #  sort = sort_by("available_at DESC, rating desc", options)
    #elsif options[:view_mode] && (options[:view_mode].to_sym == :recent || options[:view_mode].to_sym == :weekly_streaming || options[:view_mode].to_sym == :soon)
    #  sort = sort_by("available_at desc", options)
    #elsif options[:view_mode] && options[:view_mode].to_sym == :cinema
    #  sort = sort_by("created_at desc", options)
    #elsif options[:filter] && options[:filter].to_sym == :vod
    #  sort = sort_by("streaming_id desc", options)
    #else
    #  sort = sort_by("default_order desc, in_stock DESC", options)
    #end
    #if sort !=""
    #  if (options[:view_mode] && (options[:view_mode].to_sym == :streaming || options[:view_mode].to_sym == :popular_streaming || options[:view_mode].to_sym == :weekly_streaming)) || (options[:filter] && options[:filter].to_sym == :vod)
    #    products = products.group('imdb_id', sort)
    #  else
    #    products = products.order(sort, :extended)
    #  end
    #else
    #  if options[:filter] && options[:filter].to_sym == :vod
    #     products = products.group('imdb_id', "streaming_id desc")
    #  end
    #end
    #if options[:limit]
  #    products = products.limit(options[:limit])
    #end
    products
    # products = products.sphinx_order('listed_products.order asc', :asc) if params[:top_id] && !params[:top_id].empty?
  end

  def recommendations(kind)
    begin
      # external service call can't be allowed to crash the app
      recommendation_ids = Moovies.product_linked_recommendations(self, kind, I18n.locale)
    rescue => e
      logger.error("Failed to retrieve recommendations: #{e.message}")
    end
    if recommendation_ids && !recommendation_ids.empty?
      if kind == :normal
        Product.available.by_products_id(recommendation_ids)
      else
        if categories.find_by_categories_id([76,72])
          Product.available.gay.by_products_id(recommendation_ids)
        else
          Product.available.hetero.by_products_id(recommendation_ids)
        end
      end
    end
  end

  def recommendations_new(kind, customer_id, type)
    begin
      # external service call can't be allowed to crash the app
      recommendation_ids = Moovies.product_linked_recommendations_new(self, kind, customer_id, type)
    rescue => e
      logger.error("Failed to retrieve recommendations: #{e.message}")
    end
    if recommendation_ids && !recommendation_ids.empty?
      if kind == :normal
        Product.search(:max_matches => 200, :per_page => 100).available.by_imdb_id(recommendation_ids).group('imdb_id', "default_order desc")
      else
        if categories.find_by_categories_id([76,72])
          Product.available.gay.by_products_id(recommendation_ids)
        else
          Product.available.hetero.by_products_id(recommendation_ids)
        end
      end
    end    
  end

  def get_recommendations(kind)
    recommendation_ids = recommendations.collect(&:recommendation_id)
    if recommendation_ids && !recommendation_ids.empty?
      if kind == :normal
        Product.search(:max_matches => 200, :per_page => 8, :page => pa).available.by_products_id(recommendation_ids).with_speaker(Moovies.product_languages[I18n.locale.to_s])
      else
        if categories.find_by_categories_id([76,72])
          Product.available.gay.by_products_id(recommendation_ids)
        else
          Product.available.hetero.by_products_id(recommendation_ids)
        end
      end
    end
  end

  def description
    descriptions.by_language(I18n.locale).first
  end

  def to_param
      public_name
  end

  def public_name
    #to do
    if ENV['HOST_OK'] == "1"
      desc = descriptions.by_language(I18n.locale).first
      desc && !desc.cached_name.nil? ? "#{id}-#{desc.cached_name}" : id
    else
      id
    end
  end

  def title
    if desc = description
      desc.title
    else
      products_title
    end
  end

  def trailer
    localized_trailers = trailers.by_language(I18n.locale.to_s)
    localized_trailers ? localized_trailers.first : nil
  end

  def image
    if desc = description
      if products_type == Moovies.product_kinds[:adult]
        File.join(Moovies.imagesx_path, desc.image)  if !desc.image.blank?
      else
        File.join(Moovies.images_path, desc.image) if !desc.image.blank?
      end
    end
  end

  def image_detail
    File.join(Moovies.images_path, 'products', "#{id}.jpg")
  end

  def description_data(full = false)
    if desc = description
      title = desc.title
      if products_type == Moovies.product_kinds[:adult]
        image = File.join(Moovies.imagesx_path, desc.image)  if !desc.image.blank?
      else
        image =  File.join(Moovies.images_path, desc.image) if !desc.image.blank?
      end
      if full
        description = desc
      else
        description = nil
      end
        
    else
      title = products_title
      image = nil
      description = nil
    end
    {:image => image, :title => title, :description => description}
  end
  
  def preview_image(id, kind)
    path = kind == :adult ? Moovies.imagesx_preview_path : Moovies.images_preview_path
    File.join(path,'small', "#{imdb_id}_#{id}.jpg")
  end

  def trailer_image(kind)
    path = kind == :adult ? Moovies.imagesx_trailer_path : Moovies.images_trailer_path
    File.join(path, "#{id}.jpg")
  end

  def banner_image(kind)
    path = kind == :adult ? Moovies.imagesx_banner_path : Moovies.images_banner_path
    File.join(path, "#{id}.jpg")
  end

  def rating(customer = nil)
    if customer && customer.has_rated?(self)
      {:rating => ratings.by_customer(customer).first.value.to_i * 2, :customer => true}
    else
      rating = rating_count == 0 ? 0 : ((rating_users.to_f / rating_count) * 2).round
      {:rating => rating, :customer => false}
    end
  end

  def rate!(value)
    if imdb_id > 0
      Product.find_all_by_imdb_id(imdb_id).each {|product| 
        product.update_attributes(:rating_count => product.rating_count+1, :rating_users => product.rating_users + value)
      }
    else
      update_attributes({:rating_count => (rating_count + 1), :rating_users => (rating_users + value)})
    end
  end

  def is_new?
    created_at < Time.now && available_at && available_at > 3.months.ago
  end

  def series?
    products_series_id != 0
  end

  def in_streaming_or_soon?
    if Rails.env == "pre_production"
      streaming_products.count > 0 || vod_next
    else
      streaming_products.available.count > 0 || vod_next
    end
  end

  def streaming?(kind =  :normal, country_id = 21)      
    sql = streaming_products
    unless Rails.env == "pre_production"
      sql = sql.available.country('BE')
    end
    sql = sql.first
    sql
  end

  def views_increment(desc)
    # Dirty raw sql.
    # This could be fixed with composite_primary_keys but version 2.3.5.1 breaks all other associations.
  end

  
  def self.sort_by(default, options={})
    if options[:sort]
      type =
      if options[:sort] == 'alpha_az'
        "descriptions_title_#{I18n.locale} asc"
      elsif options[:sort] == 'alpha_za'
        "descriptions_title_#{I18n.locale} desc"
      elsif options[:sort] == 'rating'
        "rating desc, in_stock DESC"
      elsif options[:sort] == 'token'
        "count_tokens desc, streaming_id desc"
      elsif options[:sort] == 'token_month'
        "count_tokens_month desc, streaming_id desc"
      elsif options[:sort] == 'most_viewed'
        "most_viewed desc"
      elsif options[:sort] == 'most_viewed_last_year'
        "most_viewed_last_year desc"
      elsif options[:sort] == 'new'
        "available_at DESC, rating desc"
      elsif options[:sort] == 'recent1'
        "default_order desc"
      elsif options[:sort] == 'recent2'
        "in_stock desc"
      elsif options[:sort] == 'recent3'
        "default_order desc, in_stock desc"
      else
        default
      end
    else
      default
    end
  end

  def self.search_clean(query_string, options={})
    qs = []
    if query_string
      qs = query_string.split.collect do |word|
        "*#{replace_specials(word)}*".gsub(/[-_]/, ' ')
      end
    end
    query_string = qs.join(' ')
    query_string = "@descriptions_title #{query_string}" if !query_string.empty?
    page = options[:page] || 1
    #to do 
    limit = options[:limit] ? options[:limit].to_i : "1000"
    per_page = options[:per_page] || self.per_page
    self.search(query_string, :max_matches => limit, :per_page => per_page, :page => page)
  end

  def self.search_clean_exact(query_string, options={})
    qs = []
    if query_string
      qs = query_string.split.collect do |word|
        replace_specials(word).gsub(/[-_]/, ' ')
      end
    end
    query_string = qs.join(' ')
    query_string = "@descriptions_title ^#{query_string}$"
    page = 1
    limit = options[:limit] ? options[:limit].to_i : "1000"
    per_page = 20
    self.search(query_string, :max_matches => limit, :per_page => per_page, :page => page)
  end

  def self.replace_specials(str)
    str.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').to_s
  end

  def self.notify_hoptoad(ghost)
    begin
      Airbrake.notify(:error_message => "Ghost record found: #{ghost.inspect}")
    rescue => e
      logger.error("Exception raised wihile notifying ghost record found: #{ghost.inspect}")
      logger.error(e.backtrace)
    end
  end

  def self.get_soon(locale)
    case locale
      when :fr
        Product.by_kind(:normal).available.soon.with_languages(1).random.limit(3)
      when :nl
        Product.by_kind(:normal).available.soon.with_subtitles(2).random.limit(3)
      when :en
        Product.by_kind(:normal).available.soon.random.limit(3)
      end
  end

  def self.get_recent(locale, kind, limit, sexuality)
    if kind == :adult
      if sexuality == 1
        Product.by_kind(kind).available.recent.random.limit(limit)
      else
        Product.by_kind(kind).available.recent.hetero.random.limit(limit)
      end
    else
      case locale
        when :fr
          Product.by_kind(kind).available.recent.with_languages(1).random.limit(limit)
        when :nl
          Product.by_kind(kind).available.recent.with_subtitles(2).random.limit(limit)
        when :en
          Product.by_kind(kind).available.recent.random.limit(limit)
        end
    end
  end

  def self.get_top_view(kind, limit, sexuality)
    if sexuality == 1
      Product.by_kind(kind).by_special_media([2,4,5]).available.limit(limit).order('count_tokens desc', :extended)
    else
      Product.by_kind(kind).by_special_media([2,4,5]).available.hetero.limit(limit).order('count_tokens desc', :extended)
    end
  end

  def adult?
    products_type == Moovies.product_kinds[:adult]
  end

  def title_test
    if imdb_id >0
      title_db = products_title.upcase
      puts title_db
      title_imdb =  open "http://www.imdb.com/title/tt#{imdb_id}/" do |data|  p=/(.*)(\(.*\))/;       title = Hpricot(data).search('//h1').text.gsub(p, "\\1"); title.gsub(/\n/,'')  end
      title_imdb = CGI.unescapeHTML(title_imdb).upcase
      if title_db == title_imdb
        puts 'ok'
      else
        puts " not ok #{title_db} <==> #{title_imdb}"
      end
    end
    return ''
  end

  def self.title_test
    
    Product.normal_available.each do |product|
      if product.imdb_id >0
        
        title_db = product.products_title.upcase
        #puts title_db
        title_imdb =  open "http://www.imdb.com/title/tt#{product.imdb_id}/" do |data|  p=/(.*)(\(.*\))/;       title = Hpricot(data).search('//h1').text.gsub(p, "\\1"); title.gsub(/\n/,'')  end
        title_imdb = CGI.unescapeHTML(title_imdb).upcase
        if title_db == title_imdb
          #puts 'ok'
        else
          puts " not ok #{title_db} <==> #{title_imdb}"
        end
      end
    end
    return ''
  end

  def trailer?
    ((Rails.env == "production" ? streaming_trailers.available.count > 0 : streaming_trailers.available_beta.count > 0) && tokens_trailers.available.first )
  end

  def trailer_streaming?
    ((Rails.env == "production" ? streaming_trailers.available.count > 0 : streaming_trailers.available_beta.count > 0) && tokens_trailers.available.first )
  end

  def self.country_short_name(country_id)
    case country_id
      when 131
        'LU'
      when 161
        'NL'
      else
        'BE'
    end
  end

end