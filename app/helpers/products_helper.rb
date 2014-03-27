#encoding: utf-8

module ProductsHelper
  def carousel_path(carousel)
    case carousel.kind
      when 'MOVIE'
        product_path(:id => carousel.reference_id, :source => @wishlist_source[:carousel])
      when 'OTHER'
        info_path(:page_name => carousel.name)
      when 'OLD_SITE'
        remote_carousel_path(t(".url_#{carousel.id}"))
      when 'DIRECTOR'
        director_products_path(:director_id => carousel.reference_id)
      when 'ACTOR'
        actor_products_path(:actor_id => carousel.reference_id)
      when 'CATEGORY'
        category_products_path(:category_id => carousel.reference_id)
      when 'CHRONICLE'
        chronicle_path(:id => carousel.reference_id)
      when 'STREAMING_PRODUCT'
        streaming_product_path(:id => carousel.reference_id, :warning => 1)
      when 'TRAILER'
        product_trailer_path(:product_id => carousel.reference_id, :source => @wishlist_source[:recommendation_hp])
      when 'THEME_EVENT'
        theme = ThemesEvent.find(carousel.reference_id)
        theme_path(:id => theme.to_param)
      when 'SURVEY'
        new_survey_customer_survey_path(:survey_id => carousel.reference_id)
      when 'CONTEST'
        contest_path(:id => carousel.reference_id)
      when 'SHOP'
        shop_path()
      when 'STUDIO'
         studio_products_path(:studio_id => carousel.reference_id)
     when 'STUDIO_VOD'
        studio_products_path(:studio_id => carousel.reference_id, :filter => :vod)
      when 'SEARCH'
        search_path(:search => carousel.reference_id)
      when 'URL'
        eval(carousel.reference_id)
      end
  end
  def get_reviews()
    if params[:sort]
      sort = Review.sort2[params[:sort].to_sym]
      review_sort = params[:sort].to_sym
      cookies[:review_sort] = { :value => params[:sort], :expires => 1.year.from_now }
    else
      if cookies[:review_sort]
        sort =  Review.sort2[cookies[:review_sort].to_sym]
        review_sort = cookies[:review_sort].to_sym
      else
        sort =  Review.sort2[:date]
        review_sort = :date
      end
    end
    if sort != Review.sort2[:interesting]
      reviews = @product.reviews.approved.ordered("#{sort} DESC, (customers_best_rating - customers_bad_rating ) DESC, customers_best_rating DESC").by_language(I18n.locale).includes([:product, :customer]).paginate(:page => params[:reviews_page], :per_page => 3)
    else
      reviews = @product.reviews.approved.ordered("(customers_best_rating - customers_bad_rating ) DESC, customers_best_rating desc, date_added DESC").by_language(I18n.locale).includes([:product, :customer]).paginate(:page => params[:reviews_page], :per_page => 3)
    end
    {:review_sort => review_sort, :reviews =>reviews }
  end

  def hide_wishlist_if_seen
    session[:indicator_stored] || !current_customer ? javascript_tag("$('#indicator-tips').hide();") : ''
  end

  def class_bubble(text, type = :classic)
    if type == :classic
      text.size == 3 ? 'small' : 'normal'
    else
      'special'
    end
  end

  def audio_bubbles(product, additional_bubble = 0, content = :li)
    audio_count=0
    total_bubble = 3 + additional_bubble 
    preferred_audio = product.languages.preferred
    audio = Array.new
    unless preferred_audio.count == 0
      audio = preferred_audio.collect{|language| 
        audio_count +=1
        content_tag(content, language.short.upcase, :class => "left red osc", :alt => language.name, :title => language.name)
      }
    end
  
    not_preferred_audio = product.languages.not_preferred
    unless not_preferred_audio.count == 0
      audio << not_preferred_audio.collect{|language| 
        audio_count +=1
        display = audio_count > total_bubble ? 'audio_hide' : ''
        if language.short
          content_tag(content, language.short.upcase, :class => "left red osc #{display}", :alt => language.name, :title => language.name)
        else
          content_tag(content, language.name,:class => "#{language.class.name.underscore}_text #{display}")
        end
      }
    end
    if audio_count > total_bubble
      audio << content_tag(content, '', :class => "audio_more")
      hide = true
    else
      hide = false
    end
    {:audio => audio, :hide => hide}
  end
  

  def subtitle_bubbles(product, additional_bubble, content = :li)
    subtitle_count=0
    total_bubble = 3 + additional_bubble 
    preferred_subtitle = product.subtitles.preferred
    sub = Array.new
    unless preferred_subtitle.count == 0
      sub = preferred_subtitle.preferred.collect{|subtitle| 
        subtitle_count += 1
        content_tag(content, subtitle.short.upcase, :class => "left gray osc", :alt => subtitle.name, :title => subtitle.name)
      }
    end
    if subtitle_count < total_bubble
       not_preferred_sub = product.subtitles.not_preferred
       unless not_preferred_sub.count == 0
         sub << not_preferred_sub.collect{|subtitle| 
          subtitle_count += 1
          display = subtitle_count > total_bubble ? 'subtitle_hide' : '' 
          if subtitle.short
            if subtitle.short.include?('_m')
              subtitle.short = subtitle.short.slice(0..1)
              class_undertitle = class_bubble(subtitle.short, :special)
            else
              class_undertitle = class_bubble(subtitle.short, :classic)
            end
            content_tag(content, subtitle.short.upcase, :class => "left gray osc #{display} #{class_undertitle}", :alt => subtitle.name, :title => subtitle.name)
          else
            content_tag(content, subtitle.name, :class => "#{subtitle.class.name.underscore}_text #{display}")
          end
        }
      end
      if subtitle_count > total_bubble
        sub << content_tag(content, '', :class => "subtitle_more")
        hide = true
      else
        hide = false
      end
    end
    {:sub => sub, :hide => hide}
  end

  def rating_review_image_links(product, replace=nil)
    links = ''
    5.times do |i|
      i += 1
      links += rating_review_image_link(product, i, replace)
    end
    links
  end

  def rating_review_image_link(product, value, replace)
    name = 'star-voted'
    class_name = 'star'
    image_name = "#{name}-off.png"

    image = image_tag(image_name, :class => class_name, :id => "star_#{product.to_param}_#{value}", :name => image_name)
    link_to image, product_rating_path(:product_id => product, :value => value, :background => :white, :replace => replace)
  end

  def review_image_links(rating)
    links = []
    5.times do |i|
      i += 1
      image_name = if rating >= 2
        "star-on.png"
      elsif rating == 1
        "star-half.png"
      else
        "star-off.png"
      end
      links << image_tag(image_name, :name => image_name, :size => '12x12')
      rating -= 2
    end
    links
  end

  def rating_image_links(product, background = nil, size = nil, replace = nil, recommendation = nil, response_id = nil, source = nil)
   if product
     rating_data = product.rating(current_customer) 
     rating = rating_data[:rating]
     rated = rating_data[:customer]
     links = ""
     5.times do |i|
       i += 1
       links += rating_image_link(product, rating, i, background, size, replace, recommendation, rated, response_id, source)
       rating -= 2
     end
     links
   end
  end

  def rating_image_link(product, rating, value, background = nil, size = nil, replace = nil, recommendation = nil, rated = nil, response_id = nil, source = nil)
    background = background.to_sym if background
    if current_customer
      if rated
        name = 'star-voted'
        class_name = ''
      else
        name = 'star'
        class_name = 'star'
      end
    else
       name = 'star'
       class_name = ''
    end

    image_name = if rating >= 2
      "#{name}-on"
    elsif rating == 1
      "#{name}-half"
    else
      "#{name}-off"
    end
    image_name += '_adult' if params[:kind] == :adult
    image_name += '.png'
    s = size == :long || size == 'long' ? '19x19' : '12x12'
    image = image_tag(image_name, :class => class_name, :id => "star_#{product.id}_#{value}", :name => image_name, :size => s)
    
    if current_customer && class_name == 'star'
      link_to(image, product_rating_path(:product_id => product, :value => value, :background => background, :size => size, :replace => replace, :recommendation => recommendation, :response_id => response_id, :source => source))
    else
      image
    end
  end

  def product_description_text(product)
    product.description.nil? || product.description.text.nil? ? '' : truncate_html(product.description.text, :length => 300)
  end

  def product_image_tag(source, options={})
    image_tag (source || File.join(I18n.locale.to_s, 'image_not_found.gif')), options
  end

  def awards(description)
    content = ''
    if description
      if !description.products_awards.empty?
        awards = description.products_awards.split(/<br>|<br \/>/)
        if count_awards(awards) > 3
          content += '<p id ="oscars_text">'
          3.times do |i|
            content += "#{awards[i]}<br />"
          end
          content += '</p>'
          content += "<p id=\"oscars\">#{link_to t('.read_more'), product_awards_path(:product_id => description.products_id)}</p>"
        else
          content += "<p>#{description.products_awards}</p>"
        end
      end
    end
  end

  def count_awards(awards)
    count = 0
    awards.each do |award|
      if !award.empty?
        count += 1
      end
    end
    count
  end

  def filter_checkbox_tag(attribute, sub_attribute, checked=false)
    check_box_tag "search_filter[#{attribute}[#{sub_attribute}]]", true, checked
  end

  def products_index_description
    pre = params[:package] == Moovies.packages.invert[1] || params[:package].nil? || params[:package] == Moovies.packages.invert[4] ? 'svod' : 'tvod'
    return "products.index.description_#{pre}_director" if params[:director_id] && !params[:director_id].blank?
    return "products.index.description_#{pre}_studio" if params[:studio_id] && !params[:studio_id].blank?
    return "products.index.description_#{pre}_actor" if params[:actor_id] && !params[:actor_id].blank?
    return "products.index.description_#{pre}_category" if params[:category_id] && !params[:category_id].blank?
    return "products.index.description_#{pre}_last_added" if params[:view_mode] == 'last_added'
    return "products.index.description_#{pre}_most_viewed" if params[:view_mode] == 'most_viewed'
    return "products.index.description_#{pre}_last_chance" if params[:view_mode] == 'last_chance'
    return "products.index.description_#{pre}_soon" if params[:view_mode] == 'soon'
    return "products.index.description_#{pre}_new" if params[:view_mode] == 'new'
    return "products.index.description_#{pre}_all"
  end

  def products_alt_banner
    pre = params[:package] == Moovies.packages.invert[1] || params[:package].nil? || params[:package] == Moovies.packages.invert[4] ? 'svod' : 'tvod'
    return "products.index.alt_banner_#{pre}_director" if params[:director_id] && !params[:director_id].blank?
    return "products.index.alt_banner_#{pre}_studio" if params[:studio_id] && !params[:studio_id].blank?
    return "products.index.alt_banner_#{pre}_actor" if params[:actor_id] && !params[:actor_id].blank?
    return "products.index.alt_banner_#{pre}_category" if params[:category_id] && !params[:category_id].blank?
    return "products.index.alt_banner_#{pre}_last_added" if params[:view_mode] == 'last_added'
    return "products.index.alt_banner_#{pre}_most_viewed" if params[:view_mode] == 'most_viewed'
    return "products.index.alt_banner_#{pre}_last_chance" if params[:view_mode] == 'last_chance'
    return "products.index.alt_banner_#{pre}_soon" if params[:view_mode] == 'soon'
    return "products.index.alt_banner_#{pre}_new" if params[:view_mode] == 'new'
    return "products.index.alt_banner_#{pre}_all"
  end

  def title_add_to_wishlist(type_text, type_button, media = nil)
    if type_button == :reserve
      if type_text == :short
        t('products.wishlist.short_reserve')
      else
        t('products.wishlist.reserve', :media => t("products.index.filters.#{media}"))
      end
    else
      if type_text == :short
        t('products.wishlist.short_add')
      else
        t('products.wishlist.add', :media => t("products.index.filters.#{media}"))
      end
    end  
  end

  def title_add_all_to_wishlist(type_button)
    if type_button == :reserve
      t('.reserve_serie')
    else
      t('.add_serie')
    end  
  end

  def title_remove_from_wishlist(type_text, media)
    if type_text == :short
      t('products.wishlist.short_remove')
    else
      t('products.wishlist.remove', :media => t("products.index.filters.#{media}"))
    end
  end

  def left_column_categories(selected_category, kind, sexuality, host_ok, view_mode)
    html_content = []
    cat = Category.active.roots.movies.by_kind(kind).remove_themes.ordered
    cat.collect do |category|
      li_style = 'display:none' if selected_category && category != selected_category && category != selected_category.parent && selected_category.active == 'YES'
      if category == selected_category
        a_class = 'actived'
      else
        li_class = 'cat'
      end
      html_content << content_tag(:li, :class => li_class, :style => li_style) do
        link_to category.name, category_products_path(:category_id => category, :view_mode => view_mode), :class => a_class
      end
      if selected_category && (category == selected_category || category == selected_category.parent)
        category.children.active.movies.by_kind(:normal).remove_themes.ordered.collect do |sub_category|
          html_content << content_tag(:li, :class => 'subcat') do
            link_to " | #{sub_category.name}", category_products_path(:category_id => sub_category, :view_mode => view_mode), :class => ('actived' if sub_category == selected_category)
          end
        end
        html_content << content_tag(:li) do
          link_to t('.category_back'), products_short_path, :id => 'all_categorie'
        end
      end
    end
    if current_customer
    li_style = selected_category ? 'display:none' : ''
      html_content << content_tag(:li, :class => :cat, :style => li_style) do
        kind == :adult ? link_to( t('.full_categories'), categories_path(:view_mode => view_mode), :id => 'catx') : link_to( t('.category_x'), root_localize_path(:kind => :adult), :id => 'catx')
      end
    end
    html_content
  end

  def streaming_audio_bublles(product, vod_next = false)
    content=''
    bubble = StreamingProduct.available_beta.where(:imdb_id => product.imdb_id).group('language_id')
    bubble.collect{
    |product|
      lang = product.language.by_language(I18n.locale).first
      if lang && lang.short
        content += content_tag(:li, lang.short.upcase, :class => "left red osc", :alt => lang.name, :title => lang.name) 
      end
    }
    content
  end

  def streaming_subtitle_bublles(product, vod_next = false)
    content=''
    bubble = StreamingProduct.available_beta.where(:imdb_id => product.imdb_id).group('subtitle_id')
    bubble.collect {
    |product|
      lang = product.subtitle.by_language(I18n.locale).first
      if lang && lang.short
        short = lang.short
        name = lang.name
        if short.include?('_m')
          short = short.slice(0..1)
          class_undertitle = class_bubble(short, :special)
        else
          class_undertitle = class_bubble(short, :classic)
        end
        content += content_tag(:li, short.upcase, :class => "left gray osc #{class_undertitle}", :alt => name, :title => name)
      end
    }
    content
  end

  def bubbles(product)
    "#{streaming_audio_bublles(product)} #{streaming_subtitle_bublles(product)}"
  end

  def product_review_stars(review, kind)
    images = ""
    review.rating.times do
      images += image_tag "star-on.png", :size => '13x13'
    end
      (5-review.rating).times do
      images += image_tag "star-off.png", :size => '13x13'
    end
    images
  end

  def green_stars(rating)
    images = ""
    rating.times do
      images += image_tag "green-star-on.png", :size => '21x20'
    end
      (5-rating).times do
      images += image_tag "green-star-off.png", :size => '21x20'
    end
    images
  end

  def expire_fragment(product)
    id = product.id
    Rails.cache.delete "views/fr/products/product2_1_1_#{id}"
    Rails.cache.delete "views/nl/products/product2_1_1_#{id}"
    Rails.cache.delete "views/en/products/product2_1_1_#{id}"
    Rails.cache.delete "views/fr/products/product2_1_0_#{id}"
    Rails.cache.delete "views/nl/products/product2_1_0_#{id}"
    Rails.cache.delete "views/en/products/product2_1_0_#{id}"
    Rails.cache.delete "views/fr/products/product2_0_1_#{id}"
    Rails.cache.delete "views/nl/products/product2_0_1_#{id}"
    Rails.cache.delete "views/en/products/product2_0_1_#{id}"
    Rails.cache.delete "views/fr/products/product2_0_0_#{id}"
    Rails.cache.delete "views/nl/products/product2_0_0_#{id}"
    Rails.cache.delete "views/en/products/product2_0_0_#{id}"
  end

  def abo_details(abo, free_upgrade=0)
    if abo.qty_dvd_max == 0
      details = "<strong>#{pluralize(abo.credits, t('.in_vod'), t('.in_vods'))}</strong>"
    else
      details =""
      details = "<strong>#{abo.qty_dvd_max} #{t '.films'}</strong> #{t '.all_formats'}"
      details += "<strong> + #{pluralize(abo.credits - abo.qty_dvd_max, t('.in_vod'), t('.in_vods'))}</strong>"
      details += "<br /> #{image_tag "freeupgradelogo.gif"}" if abo.ordered == free_upgrade 
    end
    details
  end


  def human_birth(people)
    if people.birth_at
      date = Date.parse(people.birth_at)
      str = "<b>#{t '.birth_at'} :</b> #{date.strftime('%d/%m/%Y') }"
      str += " #{t '.at'} #{people.birth_place}<br>" if people.birth_place
      str.html_safe
    else
      ''
    end
    
  end

  def human_death(people)
    if people.death_at
      str = "<b>#{t '.death_at'} :</b> #{people.death_at.strftime('%d/%m/%Y') }"
      str += " #{t '.at'} #{people.death_place}<br>" if people.death_place
      str.html_safe
    else
      ''
    end
  end

  def category(product, cat)
    if cat
      cat.name
    else
      if product.adult?  
        product.categories.first.name unless product.categories.empty?
      else
        product.categories.active.first.name unless product.categories.active.empty?
      end
    end
  end

  def sort_collection_for_select
    options = []
    codes_hash = Product.list_sort
    codes_hash.each {|key, code| options.push [t(".#{key}"), key]}
    options
  end

  def menu_show(id, params, product)
    if params[:controller] == 'products' && params[:action] == 'index'
      if id == Moovies.packages[params[:package]] || ((id == 1 || id == 4) && params[:package].nil?)
        "block"
      else
        "none"
      end
    elsif params[:controller] == 'products' && params[:action] == 'show'
      if id == product.package_id
        "block"
      else
        "none"
      end
    else
      "block"
    end
  end

  def get_type(product, svod_date)
    if svod_date && svod_date.start_on <= Date.today
      "SVOD"
    else
      "TVOD"
    end
  end

  def get_vod_message(vod, svod_date, kind, package)
    if vod.available?
      
      if svod_date && svod_date.start_on > Date.today && svod_date.start_on < Date.today+30.days
        "<td class='goinfinite'>#{t('.soon_in_svod_' + kind, :days => (svod_date.start_on - Date.today).to_i).html_safe}</td>".html_safe
      elsif svod_date && svod_date.end_on > Date.today && svod_date.end_on < Date.today+30.days && vod.expire_at && vod.expire_at > Date.today
        "<td class='goalacarte'>#{t('.soon_in_tvod', :days => (svod_date.end_on - Date.today).to_i).html_safe}</td>".html_safe
      elsif svod_date && svod_date.end_on == Date.today
        "<td class='goalacarte'>#{t('.tomorrow_in_tvod')}</td>".html_safe
      elsif vod.expire_at && vod.expire_at > Date.today && vod.expire_at < Date.today+30.days
        "<td class='noavailable'>#{t('.last_chance', :days => (vod.expire_at - Date.today).to_i).html_safe}</td>".html_safe
      elsif vod.expire_backcatalogue_at && vod.expire_backcatalogue_at > Date.today && vod.expire_backcatalogue_at < Date.today+30.days
        "<td class='noavailable'>#{t('.last_chance', :days => (vod.expire_backcatalogue_at - Date.today).to_i).html_safe}</td>".html_safe
      else
        "<td></td>".html_safe
      end
    else
      if vod.available_from && vod.available_from > Date.today
        "<td>#{t('.available_soon_'+ package.to_s, :days => (vod.available_from - Date.today).to_i).html_safe}".html_safe
      elsif vod.available_backcatalogue_from && vod.available_backcatalogue_from > Date.today
        "<td>#{t('.available_soon_'+ package.to_s, :days => (vod.available_backcatalogue_from - Date.today).to_i).html_safe}</td>".html_safe
      elsif vod.expire_backcatalogue_at && vod.expire_backcatalogue_at < Date.today
        "<td>#{t('.not_available_anymore').html_safe}</td>".html_safe
      else
        "<td>#{t('.soon').html_safe}</td>".html_safe
      end
    end
  end

  def ratings_array(rating, kind)
    rating = rating[:rating]
    rating_array = []
    5.times do |i|
      i += 1
      if rating >=2
        rating_array << "star-on#{kind == :adult ? '_adult' : ''}.png"
      elsif rating == 1
        rating_array << "star-half#{kind == :adult ? '_adult' : ''}.png"
      else
        rating_array << "star-off#{kind == :adult ? '_adult' : ''}.png"
      end
      rating -= 2
    end
    rating_array
  end

  def actors_list(product)
    list = []
    if product.actors.size > 0
      product.actors.each do |actor|
        list << "<a href='http://www.plush.be/#{I18n.locale}/#{params[:kind] == :adult ? 'adult/' : ''}actors/#{actor.slug}/products' style='color:  rgb(43, 56, 64); text-decoration: none;' target='_blank'>#{actor.name}</a>"
      end
    end
    list.join(', ')
  end
end
