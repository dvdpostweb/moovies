class Product < ActiveRecord::Base
  include ThinkingSphinx::Scopes
  cattr_reader :per_page
  self.primary_key = :products_id
  #self.table_name_prefix = "#{Rails.configuration.database_configuration["#{Rails.env}"]['database']}."

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
  alias_attribute :studio_id,       :products_studio
  alias_attribute :qty_sale,        :quantity_to_sale
  alias_attribute :price_sale,      :products_sale_price
  
  belongs_to :director, :foreign_key => :products_directors_id
  belongs_to :package
  belongs_to :studio, :foreign_key => :products_studio
  belongs_to :country, :class_name => 'ProductCountry', :foreign_key => :products_countries_id
  belongs_to :picture_format, :foreign_key => :products_picture_format, :conditions => {:language_id => Moovies.languages[I18n.locale.to_s]}
  has_many :lists
  has_one :public, :primary_key => :products_public, :foreign_key => :public_id, :conditions => {:language_id => Moovies.languages[I18n.locale.to_s]}
  has_many :descriptions, :class_name => 'ProductDescription', :foreign_key => :products_id
  has_many :descriptions_fr, :class_name => 'ProductDescription', :foreign_key => :products_id, :conditions => {:language_id => 1}
  has_many :descriptions_nl, :class_name => 'ProductDescription', :foreign_key => :products_id, :conditions => {:language_id => 2}
  has_many :descriptions_en, :class_name => 'ProductDescription', :foreign_key => :products_id, :conditions => {:language_id => 3}
  has_many :ratings, :foreign_key => :products_id
  has_many :reviews, :foreign_key => :imdb_id, :primary_key => :imdb_id
  has_many :uninteresteds, :foreign_key => :products_id
  has_many :uninterested_customers, :through => :uninteresteds, :source => :customer, :uniq => true
  has_many :streaming_products, :class_name => 'StreamingProduct', :foreign_key => :imdb_id, :primary_key => :imdb_id, :conditions => "streaming_products.available = 1 and streaming_products.country ='BE'"
  has_many :streaming_products_be, :class_name => 'StreamingProduct', :foreign_key => :imdb_id, :primary_key => :imdb_id, :conditions => "streaming_products.available = 1 and streaming_products.country ='BE' and streaming_products.status in ('online_test_ok', 'soon', 'uploaded') and (streaming_products.expire_backcatalogue_at is null or streaming_products.expire_backcatalogue_at > now())"
  has_many :streaming_products_lu, :class_name => 'StreamingProduct', :foreign_key => :imdb_id, :primary_key => :imdb_id, :conditions => "streaming_products.available = 1 and streaming_products.country ='LU' and streaming_products.status in ('online_test_ok', 'soon', 'uploaded') and (streaming_products.expire_backcatalogue_at is null or streaming_products.expire_backcatalogue_at > now())"
  has_many :streaming_products_nl, :class_name => 'StreamingProduct', :foreign_key => :imdb_id, :primary_key => :imdb_id, :conditions => "streaming_products.available = 1 and streaming_products.country ='NL' and streaming_products.status in ('online_test_ok', 'soon', 'uploaded') and (streaming_products.expire_backcatalogue_at is null or streaming_products.expire_backcatalogue_at > now())"
  has_many :vod_online_be, :class_name => 'StreamingProduct', :foreign_key => :imdb_id, :primary_key => :imdb_id, :conditions => "streaming_products.available = 1 and streaming_products.country ='BE' and streaming_products.status = 'online_test_ok' and ((streaming_products.available_from <= date(now()) and streaming_products.expire_at >= date(now())) or (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now())))"
  has_many :vod_online_lu, :class_name => 'StreamingProduct', :foreign_key => :imdb_id, :primary_key => :imdb_id, :conditions => "streaming_products.available = 1 and streaming_products.country ='lu' and streaming_products.status = 'online_test_ok' and ((streaming_products.available_from <= date(now()) and streaming_products.expire_at >= date(now())) or (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now())))"
  has_many :vod_online_nl, :class_name => 'StreamingProduct', :foreign_key => :imdb_id, :primary_key => :imdb_id, :conditions => "streaming_products.available = 1 and streaming_products.country ='NL' and streaming_products.status = 'online_test_ok' and ((streaming_products.available_from <= date(now()) and streaming_products.expire_at >= date(now())) or (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now())))"
  has_many :tokens, :foreign_key => :imdb_id, :primary_key => :imdb_id
  has_many :streaming_trailers, :foreign_key => :imdb_id, :primary_key => :imdb_id, :conditions => "streaming_trailers.available = 1 and streaming_trailers.status = 'online_test_ok'"
  has_many :tokens_trailers, :foreign_key => :imdb_id, :primary_key => :imdb_id
  has_many :svod_dates, :foreign_key => :imdb_id, :primary_key => :imdb_id
  has_many :svod_dates_online, :class_name => 'SvodDate', :foreign_key => :imdb_id, :primary_key => :imdb_id, :conditions => "start_on <= date(now()) and end_on >= date(now())"
  has_many :vod_wishlists, :primary_key => :imdb_id, :foreign_key => :imdb_id
  
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
  sphinx_scope(:by_right)                 {{:with =>          {:streaming_imdb_id => 1..3147483647}}}
  sphinx_scope(:by_products_id)           {|products_id|      {:with =>       {:product_id => products_id}}}
  sphinx_scope(:exclude_products_id)      {|products_id|      {:without =>    {:product_id => products_id}}}
  sphinx_scope(:by_actor)                 {|actor|            {:with =>       {:actors_id => actor.to_param}}}
  sphinx_scope(:by_audience)              {|min, max|         {:with =>       {:audience => Public.legacy_age_ids(min, max)}}}
  sphinx_scope(:by_category)              {|category|         {:with =>       {:category_id => category}}}
  sphinx_scope(:hetero)                   {{:without =>       {:category_id => [76, 72]}}}
  sphinx_scope(:gay)                      {{:with =>          {:category_id => [76, 72]}}}
  sphinx_scope(:by_country)               {|country|          {:with =>       {:country_id => country.to_param}}}
  sphinx_scope(:by_countries_id)          {|countries_id|     {:with =>       {:country_id => countries_id}}}
  sphinx_scope(:by_director)              {|director|         {:with =>       {:director_id => director.to_param}}}
  sphinx_scope(:by_studio)                {|studio|           {:with =>       {:studio_id => studio.to_param}}}
  sphinx_scope(:by_streaming_studio)      {|studio|           {:with =>       {:streaming_studio_id => studio.to_param}}}
  sphinx_scope(:by_imdb_id)               {|imdb_id|          {:with =>       {:imdb_id => imdb_id}}}
  sphinx_scope(:by_streaming_imdb_id)     {|imdb_id|          {:with =>       {:streaming_imdb_id => imdb_id}}}
  sphinx_scope(:by_language)              {|language|         {:order =>      language.to_s == 'fr' ? :french : :dutch, :sort_mode => :desc}}
  sphinx_scope(:by_kind)                  {|kind|             {:with =>       {:kind => Zlib::crc32(Moovies.product_kinds[kind])}}}
  sphinx_scope(:by_period)                {|min, max|         {:with =>       {:year => min..max}}}
  sphinx_scope(:by_products_list)         {|product_list|     {:with =>       {:products_list_ids => product_list.to_param}}}
  sphinx_scope(:by_ratings)               {|min, max|         {:with =>       {:rating => min..max}}}
  sphinx_scope(:by_recommended_ids)       {|recommended_ids|  {:with =>       {:id => recommended_ids}}}
  sphinx_scope(:with_languages)           {|language_ids|     {:with =>       {:language_ids => language_ids}}}
  sphinx_scope(:with_subtitles)           {|sub_ids|          {:with =>       {:subtitle_ids => sub_ids}}}
  sphinx_scope(:with_speaker)             {|speaker_ids|      {:with =>       {:speaker => speaker_ids}}}
  sphinx_scope(:available)                {{:without =>       {:state => 99}}}
  sphinx_scope(:recent)                   {{:without =>       {:availability => 0}, :with => {:available_at => 2.months.ago..Time.now.end_of_day, :next => 0}}}
  sphinx_scope(:svod_soon)                {{:with =>          {:svod_start => Time.now.end_of_day..1.months.from_now}}}
  sphinx_scope(:tvod_soon)                {{:without =>          {:tvod_start_combi => 0}}}
  sphinx_scope(:tvod_soon2)                {{:with =>         {:tvod_start => 0}}}
  
  sphinx_scope(:svod_last_added)          {{:with =>          {:svod_start => 3.months.ago..Time.now.end_of_day, :imdb_id_online => 1..3147483647}}}
  sphinx_scope(:tvod_last_added)          {{:with =>          {:tvod_start => 5.months.ago..1.day.ago, :imdb_id_online => 1..3147483647}}}
  sphinx_scope(:svod_last_chance)         {{:with =>          {:svod_end => Time.now.end_of_day..1.months.from_now}}}
  sphinx_scope(:best_rated)               {{:with =>          {:rating => 3.0..5.0}}}
  
  sphinx_scope(:tvod_last_chance)         {{:with =>          {:streaming_expire_at => Time.now.end_of_day..1.months.from_now}}}
  sphinx_scope(:most_viewed)              {{:with =>          {:count_tokens => 1..1000000}}}
  sphinx_scope(:by_package)               {|package_id|       {:with =>          {:package_id => package_id}}}
  sphinx_scope(:random)                   {{:order =>         '@random'}}
  sphinx_scope(:by_new)                   {{:with =>          {:year => 2.years.ago.year..Date.today.year, :imdb_id_online => 1..3147483647}}}
  sphinx_scope(:hd)                       {{:with =>          {:hd => 1, :imdb_id_online => 1..3147483647}}}
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
  def self.filter_online(filters, options={}, exact=nil)
    products = Product.by_kind(options[:kind])
    products = products.exclude_products_id([exact.collect(&:products_id)]) if exact
    products = products.by_actor(options[:actor_id]) if options[:actor_id]
    #products = products.by_category(options[:category_id]) if options[:category_id]
    products = products.hetero if options[:hetero] && (options[:category_id] && (options[:category_id].to_i != 76 && options[:category_id].to_i != 72) )
    products = products.by_director(options[:director_id]) if options[:director_id]
    products = products.by_imdb_id(options[:imdb_id]) if options[:imdb_id]
    products = options[:kind] == :normal ? products.by_streaming_studio(options[:studio_id]) : products.by_studio(options[:studio_id]) if options[:studio_id]
    products = products.by_package(Moovies.packages[options[:package]]) if options[:package] && (options[:view_mode] != 'svod_soon' && options[:view_mode] != 'tvod_soon')
    
    if options[:filters]
      products = products.by_audience(options[:filters][:audience_min], options[:filters][:audience_max]) if Product.audience?(options[:filters][:audience_min], options[:filters][:audience_max]) && options[:kind] == :normal
      products = products.by_countries_id(options[:filters][:country_id].reject(&:empty?)) if Product.countries?(options[:filters][:country_id])
      products = products.by_ratings(options[:filters][:rating_min].to_f, options[:filters][:rating_max].to_f) if Product.rating?(options[:filters][:rating_min], options[:filters][:rating_max])
      products = products.by_period(options[:date][:filters][:year_min], options[:date][:filters][:year_max]) if options[:date] && Product.year?(options[:date][:filters][:year_min], options[:date][:filters][:year_max])
      products = products.with_languages(audio = options[:filters][:audio].reject(&:empty?) ) if Product.audio?(options[:filters][:audio])
      products = products.with_subtitles(options[:filters][:subtitles].reject(&:empty?)) if Product.subtitle?(options[:filters][:subtitles])
      products = products.by_category(options[:filters][:category_id]) if !options[:filters][:category_id].nil? && !options[:filters][:category_id].blank?
    end
    products = self.get_view_mode(products, options[:view_mode]) if options[:view_mode]
    sort = get_sort(options)
    products = products.order(sort, :extended) if sort != ''
    products = search_clean(products, options[:search], {:page => options[:page], :per_page => options[:per_page], :limit => options[:limit], :country_id => options[:country_id], :includes => options[:includes]})
    
    products
  end
  def self.filter(filters, options={}, exact=nil)
    if options[:package].nil? && options[:controller] != 'search' && options[:concerns] != :productable
      id = options[:kind] == :normal ? 1 : 4
      options[:package] = Moovies.packages.invert[id]
    end
    products = Product.by_kind(options[:kind])
    products = products.exclude_products_id([exact.collect(&:products_id)]) if exact
    products = products.by_actor(options[:actor_id]) if options[:actor_id]
    products = products.by_category(options[:category_id]) if options[:category_id]
    products = products.hetero if options[:hetero] && (options[:category_id] && (options[:category_id].to_i != 76 && options[:category_id].to_i != 72) )
    products = products.by_director(options[:director_id]) if options[:director_id]
    products = products.by_imdb_id(options[:imdb_id]) if options[:imdb_id]
    products = options[:kind] == :normal ? products.by_streaming_studio(options[:studio_id]) : products.by_studio(options[:studio_id]) if options[:studio_id]
    if !filters.nil?  
      products = products.by_audience(filters.audience_min, filters.audience_max) if filters.audience? && options[:kind] == :normal
      products = products.by_country(filters.country_id) if filters.country_id?
      products = products.by_ratings(filters.rating_min.to_f, filters.rating_max.to_f) if filters.rating?
      products = products.by_period(filters.year_min, filters.year_max) if filters.year?
      products = products.with_languages(options[:audio] ? options[:audio] : filters.audio) if filters.audio?
      products = products.with_subtitles(options[:subtitles]? options[:subtitles] : filters.subtitles) if filters.subtitles?
    end
    products = products.by_package(Moovies.packages[options[:package]]) if options[:package] && (options[:view_mode] != 'svod_soon' && options[:view_mode] != 'tvod_soon')
    products = self.get_view_mode(products, options[:view_mode]) if options[:view_mode]
    sort = get_sort(options)
    products = products.order(sort, :extended) if sort != ''
    products = search_clean(products, options[:search], {:page => options[:page], :per_page => options[:per_page], :limit => options[:limit], :country_id => options[:country_id], :includes => options[:includes]})
    
    products
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
    case I18n.locale
      when :nl
        descriptions_nl.first
      when :en
        descriptions_en.first
      else
        descriptions_fr.first
      end
  end

  def self.year?(year_min, year_max)
    !(year_min.nil? && year_max.nil?) && !((year_min.to_i == 0 || year_min.to_i == 1910) && year_max.to_i >= Time.now.year)
  end

  def self.audience?(audience_min, audience_max)
    !(audience_min.nil? && audience_max.nil?) && !(audience_min.to_i == 0 && audience_max.to_i == 18)
  end

  def self.rating?(rating_min, rating_max)
    !(rating_min.nil? && rating_max.nil?) && !(rating_min.to_i == 1 && rating_max.to_i == 5)
  end

  def self.countries?(countries_id)
    countries_id.reject(&:empty?).size > 0 if countries_id
  end

  def self.audio?(audios)
    audios.reject(&:empty?).size > 0 if audios
  end

  def self.subtitle?(subtitles)
    subtitles.reject(&:empty?).size > 0 if subtitles
  end

  def to_param
      public_name
  end

  def public_name
    desc = description
    desc && !desc.cached_name.nil? ? "#{id}-#{desc.cached_name}" : id
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
    false
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
  
  def self.search_clean(products, query_string, options={})
    qs = []
    if query_string
      query_string = query_string.gsub(/[_-]/, ' ').gsub(/["\(\)]/, ' ').gsub(/[@$!^\/\\|]/, '').gsub(' et ',' ')
      qs = query_string.split.collect do |word|
        "#{replace_specials(word)}*"
      end  
      search = "@descriptions_title #{qs.join(' ')}" unless query_string.empty?
    else
      search = ''
    end
    page = options[:page] || 1
    limit = options[:limit] ? options[:limit].to_i : "1000"
    per_page = options[:per_page] || self.per_page

    name = 
    case options[:country_id] 
      when 131 
        'lu'
      when 161 
        'nl'
      else 
        'be'
    end
    options[:includes] = ["vod_online_#{name}", :director, :actors, :public, :streaming_trailers, :tokens_trailers, "descriptions_#{I18n.locale}", :svod_dates_online] if options[:includes].nil?
    products.search(search, :max_matches => limit, :per_page => per_page, :page => page, :indices => ["product_#{name}_core"], :sql => { :include => options[:includes]}, :select => "*, IF(tvod_start = 0, 10402410456, if(tvod_start > 1402410456 and tvod_start <1405003931, tvod_start,0)) AS tvod_start_combi")
  end

  def self.replace_specials(str)
    str #= String_class.removeaccents(str)
    #str.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').to_s
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

  def trailer?
    ((Rails.env == "production" ? !streaming_trailers.empty? : !streaming_trailers.empty?) && !tokens_trailers.empty? )
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

  def get_vod_online(country_id)
    case country_id
       when 131
         vod_online_lu
       when 161
         vod_online_nl
       else
         vod_online_be
    end
  end
  
  def self.get_vod_online_name(country_id)
    case country_id
       when 131
         'vod_online_lu'
       when 161
         'vod_online_nl'
       else
         'vod_online_be'
    end
  end
  
  def get_vod(country_id)
    case country_id
       when 131
         streaming_products_lu
       when 161
         streaming_products_nl
       else
         streaming_products_be
    end
  end
  def self.get_view_mode(products, view_mode)
    case view_mode.to_sym
    when :svod_hd
        products.hd
    when :tvod_hd
        products.hd
    when :recent
      products.recent
    when :svod_new
      products.by_new
    when :tvod_new
      products.by_new
    when :svod_soon
      products.svod_soon
    when :svod_last_added
      products.svod_last_added
    when :svod_last_chance
      products.svod_last_chance
    when :tvod_soon
      products.tvod_soon
    when :tvod_last_added
      products.tvod_last_added
    when :tvod_last_chance
      products.tvod_last_chance
    when :tvod_most_viewed
      products.most_viewed
    when :svod_most_viewed
      products.most_viewed
    when :tvod_best_rated
      products.best_rated
    when :svod_best_rated
      products.best_rated
    when :most_viewed
      products.most_viewed
    else
      products
    end
  end

  def self.get_sort(options)
    if !options[:sort].nil? && !options[:sort].empty? && options[:sort] != 'normal'
      if options[:sort] == 'alpha_az'
        "descriptions_title_#{I18n.locale} ASC"
      elsif options[:sort] == 'alpha_za'
        "descriptions_title_#{I18n.locale} DESC"
      elsif options[:sort] == 'rating'
        "rating DESC, year DESC"
      elsif options[:sort] == 'token'
        "count_tokens DESC, streaming_id DESC"
      elsif options[:sort] == 'token_month'
        "count_tokens_month DESC, streaming_id DESC"
      elsif options[:sort] == 'most_viewed'
        "count_tokens DESC"
      elsif options[:sort] == 'most_viewed_last_year'
        "count_tokens DESC"
      elsif options[:sort] == 'new'
        "year DESC, streaming_available_at_order DESC"
      else
        "streaming_available_at_order DESC, rating DESC"
      end
    else
      if options[:list_id] && !options[:list_id].blank?
        "special_order asc"
      elsif options[:search] && !options[:search].blank?
        ''
      elsif options[:view_mode] && options[:view_mode] == 'svod_last_added'
        'svod_start DESC, streaming_available_at_order DESC, rating DESC'
      elsif options[:view_mode] && options[:view_mode] == 'svod_last_chance'
        'svod_end ASC, streaming_available_at_order DESC, rating DESC'
      elsif options[:view_mode] && options[:view_mode] == 'svod_soon'
        'svod_start DESC, streaming_available_at_order DESC, rating DESC'
      elsif options[:view_mode] && options[:view_mode] == 'tvod_soon'
        'tvod_start_combi ASC, year DESC, rating DESC'
      elsif options[:view_mode] && options[:view_mode] == 'svod_new'
        'year DESC, svod_start DESC, streaming_available_at_order DESC, rating DESC'
      elsif options[:view_mode] && options[:view_mode] == 'tvod_new'
        'year DESC, streaming_available_at_order DESC, rating DESC'
      elsif options[:view_mode] && options[:view_mode] == 'tvod_last_added'
        'tvod_start DESC, streaming_available_at_order DESC, rating DESC'
      elsif options[:view_mode] && options[:view_mode] == 'tvod_last_chance'
        'tvod_end ASC, year DESC, rating DESC'
      elsif options[:view_mode] && options[:view_mode] == 'most_viewed'
        'count_tokens DESC, year DESC, rating DESC'
      elsif options[:view_mode] && options[:view_mode] == 'svod_best_rated'
        'rating DESC, year DESC'
      elsif options[:view_mode] && options[:view_mode] == 'tvod_best_rated'
        'rating DESC, year DESC'
      elsif options[:view_mode] && options[:view_mode] == 'tvod_most_viewed'
        'count_tokens DESC, year DESC, rating DESC'
      elsif options[:view_mode] && options[:view_mode] == 'svod_most_viewed'
        'count_tokens DESC, year DESC, rating DESC'
      else
        "count_tokens DESC"
      end
    end
  end

  def hd?(country)
    self.get_vod(country).hd.size > 0
  end

  def svod?
    !svod_dates.svod.empty?
  end

  def self.update_package
    sql = "update products p
        join (select if((start_on <=date(now()) and end_on >= date(now()) or (group_concat(distinct status)='uploaded' and start_on > now()) or ((start_on = min(available_from) and start_on >= date(now())) or (start_on = min(available_backcatalogue_from) and start_on >= date(now()) and (expire_at < date(now()) or expire_at is null)))), 1,2) package,products_id
        from products p
        left join `streaming_products` sp on sp.imdb_id = p.`imdb_id` and available=1 and status <> 'deleted' and status <> 'local_test_fail'
        left join `svod_dates` s on s.imdb_id = p.imdb_id and ((start_on <= date(now()) and end_on >=now()) or (start_on > date(now())) )
        where products_type='dvd_norm'  group by p.imdb_id) sp on sp.products_id = p.products_id
        set package_id = package;
    "
    ActiveRecord::Base.connection.execute(sql)
    sql2 = "update products p
        join (select if((start_on <=date(now()) and end_on >= date(now()) or (group_concat(distinct status)='uploaded' and start_on > now()) or ((start_on = min(available_from) and start_on >= date(now())) or (start_on = min(available_backcatalogue_from) and start_on >= date(now()) and (expire_at < date(now()) or expire_at is null)))), 4,5) package,products_id
        from products p
        left join `streaming_products` sp on sp.imdb_id = p.`imdb_id` and available=1 and status <> 'deleted' and status <> 'local_test_fail'
        left join `svod_dates` s on s.imdb_id = p.imdb_id and ((start_on <= date(now()) and end_on >=now()) or (start_on > date(now())) )
        where products_type='dvd_adult'  group by p.imdb_id) sp on sp.products_id = p.products_id
        set package_id = package;
    "
    ActiveRecord::Base.connection.execute(sql2)
    
  end
  def self.get_product_home
    HomeProduct.where(:kind => ['svod', 'tvod']).destroy_all
    ['tvod', 'svod'].each do |type|
      [1,2,3].each do |locale_id|
        ['be', 'nl', 'lu'].each do |country|
          package_id = type == 'svod' ? 1 : 2
          products = Product.search(:per_page => 6, :with => { :audio_sub => locale_id, :kind => Zlib::crc32(Moovies.product_kinds[:normal]), :package_id => package_id}, :indices => ["product_#{country}_core"])
          products = type == 'svod' ?  products.search(:with => {:svod_start => 6.months.ago..Time.now.end_of_day, :studio_id => 11}).order('svod_start desc, streaming_available_at_order DESC, rating desc') : products.search(:with => {:tvod_start => 5.months.ago..Time.now.end_of_day}).order("year DESC, tvod_start DESC, streaming_available_at_order DESC, rating DESC")
          products.each do |p|
            HomeProduct.create(:product_id => p.id, :country => country, :locale_id => locale_id, :kind => type)
          end
        end
      end
    end
  end

  def self.get_product_home_adult
    HomeProduct.where(:kind => ['svod_adult', 'tvod_adult']).destroy_all
    filter = SearchFilter.get_filter(nil)
    ['tvod', 'svod'].each do |type|
      [1,2,3].each do |locale_id|
        ['be', 'nl', 'lu'].each do |country|
          package_id = type == 'svod' ? 4 : 5
          #products = Product.search(:per_page => 6, :with => { :audio_sub => locale_id, :kind => Zlib::crc32(Moovies.product_kinds[:adult]), :package_id => package_id}, :indices => ["product_#{country}_core"])
          #products = type == 'svod' ?  products.search(:with => {:svod_start => 6.months.ago..Time.now.end_of_day, :studio_id => 11}).order('year DESC, svod_start DESC, streaming_available_at_order DESC, rating DESC') : products.search(:with => {:tvod_start => 5.months.ago..Time.now.end_of_day}).order("year DESC, rating desc")
          products = filter(filter, {:view_mode => "#{type}_new", :per_page => 6, :kind => :adult, :package => Moovies.packages.invert[package_id]})
          products.each do |p|
            HomeProduct.create(:product_id => p.id, :country => country, :locale_id => locale_id, :kind => "#{type}_adult")
          end
        end
      end
    end
  end
end