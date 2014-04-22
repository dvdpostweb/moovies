class StreamingProductsController < ApplicationController
  def show
    if params[:streaming_code]
      @code = StreamingCode.by_name(params[:streaming_code]).available.first
    end
    if @code.nil? && !current_customer
      if request.xhr?
        render :partial => 'streaming_products/no_player', :locals => {:token => nil, :error => Token.error[:code_expired]}, :layout => false
      else  
        flash[:error] = t('streaming_products.code_expired')
        redirect_to root_localize_path and return
      end
    else
      @body_id = 'streaming'
      @vod_create_token = "1"#General.find_by_CodeType('VOD_CREATE_TOKEN').value
      @vod_disable = "1" #General.find_by_CodeType('VOD_ONLINE').value
      if Rails.env != 'pre_production' 
        @product = Product.both_available.find_by_imdb_id(params[:id])
      else
        @product = Product.find_by_imdb_id(params[:id])
      end
      if @product && current_customer
        @token = current_customer.get_token(@product.imdb_id)
      end
      @token_valid = @token.nil? ? false : @token.validate?(request.remote_ip)
      if Rails.env != 'pre_production' && @token_valid == false
        @streaming = StreamingProduct.available.country(Product.country_short_name(session[:country_id])).find_by_imdb_id(params[:id])
        @streaming_prefered = StreamingProduct.group_by_language.country(Product.country_short_name(session[:country_id])).available.find_all_by_imdb_id(params[:id], I18n.locale)
        @streaming_not_prefered = nil
      elsif Rails.env != 'pre_production' && @token_valid == true
        @streaming = StreamingProduct.available_token.country(Product.country_short_name(session[:country_id])).find_by_imdb_id(params[:id])
        @streaming_prefered = StreamingProduct.group_by_language.country(Product.country_short_name(session[:country_id])).available_token.find_all_by_imdb_id(params[:id], I18n.locale)
        @streaming_not_prefered = nil
      else
        @streaming = StreamingProduct.available_beta.country(Product.country_short_name(session[:country_id])).alpha.find_by_imdb_id(params[:id])
        @streaming_prefered = StreamingProduct.alpha.country(Product.country_short_name(session[:country_id])).group_by_language.find_all_by_imdb_id(params[:id], I18n.locale)
        @streaming_not_prefered = nil
      end
    
      if !request.xhr?
        if @product
          if @vod_disable == "1" || Rails.env == "pre_production"
            if view_context.streaming_access? && (@code || (current_customer.actived? && !current_customer.suspended? && current_customer.subscription_type.packages_ids.split(',').include?(@product.package_id.to_s) && (@product.svod? || (!@product.svod? && current_customer.payable?))))
              if !@streaming_prefered.blank? || !@streaming_not_prefered.blank?
                if @token_valid == false && @vod_create_token == "0" && Rails.env != "pre_production"
                  error = t('streaming_products.not_available.offline')
                  show_error(error, @code)
                else
                  render :action => :show
                end
              else
                error = t('streaming_products.not_available.not_available')
                show_error(error, @code)
              end
            else
               error = t('streaming_products.no_access.no_access')
               show_error(error, @code)
            end  
          else
            error = t('streaming_products.not_available.offline')
            show_error(error, @code)
          end
        else
          error = t('streaming_products.not_available.not_available')
          show_error(error, @code)
        end
      else
        if view_context.streaming_access?
          streaming_version = StreamingProduct.find_by_id(params[:streaming_product_id])
          if @code || ((!current_customer.suspended? && !Token.dvdpost_ip?(request.remote_ip) && !current_customer.super_user? && !(/^192(.*)/.match(request.remote_ip)) && current_customer.actived? && current_customer.subscription_type.packages_ids.split(',').include?(@product.package_id.to_s) && (@product.svod? || (!@product.svod? && current_customer.payable?))))
          #if 1==1
            status = @token.nil? ? nil : @token.current_status(request.remote_ip)
            streaming_version = StreamingProduct.find_by_id(params[:streaming_product_id])
            if !@token || status == Token.status[:expired]
              if @code
                if @code.used_at.nil?
                  send_mail = true
                else
                  send_mail = false
                end
                creation = Token.create_token(params[:id], @product, request.remote_ip, params[:streaming_product_id], params[:kind], current_customer ? current_customer : nil, params[:source], @code.name)
              elsif current_customer
                creation = Token.create_token(params[:id], @product, request.remote_ip, params[:streaming_product_id], params[:kind], current_customer, params[:source])
              else
                creation = nil
              end
              if creation
                @token = creation[:token]
                error = creation[:error]
                if params[:email] && @code && !@code.mail_id.nil? && send_mail
                   view_context.send_message_public(@code.mail_id, {}, I18n.locale, params[:email])
                end
                if current_customer && @token && !@product.svod?
                  type = "#{@product.svod? ? 'svod' : 'tvod'}_#{params[:kind]}".to_sym
                  mail_id = Moovies.email[type]
                  product_id = @product.id
                  imdb_id = @product.imdb_id
                  if current_customer.gender == 'm'
                    gender = t('mails.gender_male')
                  else
                    gender = t('mails.gender_female')
                  end
                
                  if @product.description
                    image = @product.description.image
                    description = @product.description.text
                  else
                    image = ''
                    description = ''
                  end
                  stars = view_context.ratings_array(@product.rating, params[:kind])
                  options = 
                  {
                    "\\$\\$\\$customers_name\\$\\$\\$" => "#{current_customer.first_name.capitalize} #{current_customer.last_name.capitalize}",
                    "\\$\\$\\$gender_simple\\$\\$\\$" => gender,
                    "\\$\\$\\$product_id\\$\\$\\$" => product_id,
                    "\\$\\$\\$imdb_id\\$\\$\\$" => imdb_id,
                    "\\$\\$\\$actors\\$\\$\\$" => view_context.actors_list(@product),
                    "\\$\\$\\$image1\\$\\$\\$" => stars[0],
                    "\\$\\$\\$image2\\$\\$\\$" => stars[1],
                    "\\$\\$\\$image3\\$\\$\\$" => stars[2],
                    "\\$\\$\\$image4\\$\\$\\$" => stars[3],
                    "\\$\\$\\$image5\\$\\$\\$" => stars[4],
                    "\\$\\$\\$name\\$\\$\\$" => @product.title,
                    "\\$\\$\\$year\\$\\$\\$" => @product.year,
                    "\\$\\$\\$image\\$\\$\\$" => image,
                    "\\$\\$\\$description\\$\\$\\$" => description,
                  }
                  if @token.lucky_cycle
                    type = "lucky_#{params[:kind]}".to_sym
                    mail_id = Moovies.email[type]
                    options = options.merge("\\$\\$\\$lucky_link\\$\\$\\$" => lucky_cycle_url(:id => @token.lucky_cycle.computed_hash))
                  end
                  if params[:kind] == :adult
                    if @product.studio
                      studio_name = @product.studio.name
                      studio_id = @product.studio.id
                    else
                      studio_name = ''
                      studio_id = ''
                    end
                    options = options.merge("\\$\\$\\$studio_name\\$\\$\\$" => studio_name, "\\$\\$\\$studio_slug\\$\\$\\$" => studio_id)
                  else
                    if @product.director
                      director_name = @product.director.name
                      cached_slug = @product.director.slug
                    else
                      director_name = ''
                      cached_slug = ''
                    end
                    options = options.merge("\\$\\$\\$director_name\\$\\$\\$" => director_name, "\\$\\$\\$director_slug\\$\\$\\$" => cached_slug)
                  end
                  view_context.send_message(mail_id, options, params[:locale], current_customer)
              
                end
              end
            end
          else
            if current_customer.payment_suspended?
              error = Token.error[:user_suspended]
            else
              error = Token.error[:user_holidays_suspended]
            end
          end
          if params[:subtitle_id]
            @sub = Subtitle.find(params[:subtitle_id])
          else
            @sub = nil
          end
          if @token
            current_customer.remove_product_from_wishlist(params[:id], request.remote_ip) if current_customer
            StreamingViewingHistory.create(:streaming_product_id => params[:streaming_product_id], :token_id => @token.to_param, :ip => request.remote_ip)
            Customer.send_evidence('PlayStart', @product.to_param, current_customer, request, {:responseid => params[:response_id], :segment1 => params[:source], :formFactor => view_context.format_text(@browser) , :rule => params[:source]}) if current_customer
            render :partial => 'streaming_products/player', :locals => {:token => @token, :filename => streaming_version.filename, :source => streaming_version.source, :streaming => streaming_version, :browser => @browser }, :layout => false
          elsif Token.dvdpost_ip?(request.remote_ip) || (current_customer && current_customer.super_user?) || (/^192(.*)/.match(request.remote_ip))
            render :partial => 'streaming_products/player', :locals => {:token => @token, :filename => streaming_version.filename, :source => streaming_version.source, :streaming => streaming_version, :browser => @browser }, :layout => false
            Customer.send_evidence('PlayStart', @product.to_param, current_customer, request, {:responseid => params[:response_id], :segment1 => params[:source], :formFactor => view_context.format_text(@browser) , :rule => params[:source]}) if current_customer
          else
            render :partial => 'streaming_products/no_player', :locals => {:token => @token, :error => error}, :layout => false
          end
        else
          render :partial => 'streaming_products/no_access', :layout => false
        end
      end
    end
  end

  def language
    params[:streaming_product_id] = params[:old_streaming_product_id] if params[:old_streaming_product_id]
    token = current_customer.get_token(params[:streaming_product_id]) if current_customer
    token_valid = token.nil? ? false : token.validate?(request.remote_ip)
    if Rails.env != 'pre_production' && token_valid == false
      @streaming_subtitle = StreamingProduct.available.country(Product.country_short_name(session[:country_id])).by_language(params[:language_id]).find_all_by_imdb_id(params[:streaming_product_id])
    elsif Rails.env != 'pre_production' && token_valid == true
      @streaming_subtitle = StreamingProduct.available_token.country(Product.country_short_name(session[:country_id])).by_language(params[:language_id]).find_all_by_imdb_id(params[:streaming_product_id])
    else
      @streaming_subtitle = StreamingProduct.available_beta.country(Product.country_short_name(session[:country_id])).alpha.by_language(params[:language_id]).find_all_by_imdb_id(params[:streaming_product_id])
    end
    render :partial => 'streaming_products/show/subtitles', :locals => {:streaming => @streaming_subtitle, :sample => params[:sample]}, :layout => false
  end

  def subtitle
    params[:streaming_product_id] = params[:old_streaming_product_id] if params[:old_streaming_product_id]
    token = current_customer.get_token(params[:streaming_product_id]) if current_customer
    token_valid = token.nil? ? false : token.validate?(request.remote_ip)
    if Rails.env != 'pre_production' && token_valid == false
      @streaming = StreamingProduct.available.find(params[:id])
    elsif Rails.env != 'pre_production' && token_valid == true
      @streaming = StreamingProduct.available_token.country(Product.country_short_name(session[:country_id])).find(params[:id])
    else
      @streaming = StreamingProduct.available_beta.alpha.country(Product.country_short_name(session[:country_id])).find(params[:id])
    end
    render :partial => 'streaming_products/show/launch', :locals => {:streaming => @streaming}, :layout => false
  end

  def versions
    params[:streaming_product_id] = params[:old_streaming_product_id] if params[:old_streaming_product_id]
    token = current_customer.get_token(params[:streaming_product_id]) if current_customer
    token_valid = token.nil? ? false : token.validate?(request.remote_ip)
    if Rails.env != 'pre_production' && token_valid == false
      @streaming_prefered = StreamingProduct.available.country(Product.country_short_name(session[:country_id])).find_all_by_imdb_id(params[:streaming_product_id], I18n.locale) 
    elsif Rails.env != 'pre_production' && token_valid == true
      @streaming_prefered = StreamingProduct.available_token.country(Product.country_short_name(session[:country_id])).find_all_by_imdb_id(params[:streaming_product_id], I18n.locale) 
    else
      @streaming_prefered = StreamingProduct.available_beta.country(Product.country_short_name(session[:country_id])).alpha.find_all_by_imdb_id(params[:streaming_product_id], I18n.locale) 
    end
    render :partial => 'streaming_products/show/versions', :locals => {:version => @streaming_prefered, :source => params[:source],  :response_id => params[:response_id]}
  end

  def sample
    @body_id = 'streaming'
    @meta_title = t("streaming_products.sample.meta_title", :default => '')
    @meta_description = t("streaming_products.sample.meta_description", :default => '')
    params[:id] = Moovies.data_sample[params[:kind]][:imdb_id]
    product_id = Moovies.data_sample[params[:kind]][:product_id]
    @product = Product.find_by_products_id(product_id)
    @streaming_prefered = StreamingProduct.group_by_language.available.find_all_by_imdb_id(params[:id], I18n.locale)
    @token_name = Moovies.token_sample[params[:kind]]
    
    if request.xhr?
      @streaming = StreamingProduct.find_by_id(params[:streaming_product_id])
      render :layout => false
    end
  end

  def faq
    @product = Product.find_by_imdb_id(params[:streaming_product_id])
    unless current_customer
      @hide_menu = false
      @customer_id = 0
    else
      @customer_id = current_customer.to_param
    end
  end

  def show_error(error, code)
    if code.nil?
      flash[:error] = error
      notify_country_error(current_customer.to_param, session[:country_id], params[:id], error)
      redirect_to root_localize_path
    else
      @error = error
      #render :partial => 'streaming_products/show/error', :locals => {:error => error}
    end
  end

  private
  def notify_country_error(customer_id, country_id, imdb_id, error)
    begin
      Airbrake.notify(:error_message => "customer have a problem with VOD customer_id : #{customer_id} country_id: #{country_id} imdb_id: #{imdb_id}, error #{error} ip #{session[:my_ip]} forwarded: #{request.env["HTTP_X_FORWARDED_FOR"]} remote: #{request.remote_ip}", :backtrace => $@, :environment_name => ENV['RAILS_ENV'])
    rescue => e
      logger.error("customer have a problem with VOD customer_id : #{customer_id} country_id: #{country_id} imdb_id: #{imdb_id} error #{error} ip #{session[:my_ip]}")
      logger.error(e.backtrace)
    end
  end
end