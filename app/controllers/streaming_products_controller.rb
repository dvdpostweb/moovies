class StreamingProductsController < ApplicationController

  def show
    params[:season_id] = params[:season_id] || 0
    params[:episode_id] = params[:episode_id] || 0
    @product = Product.both_available.where(:imdb_id => params[:id], :season_id => params[:season_id], :episode_id => params[:episode_id]).first
    if @product && current_customer
      @token = current_customer.get_token(@product.imdb_id, @product.season_id, @product.episode_id)
      gon.token = @token
    end
    @token_valid = @token.nil? ? false : @token.validate?(request.remote_ip)
    if @token_valid == false
      @streaming = StreamingProduct.available.country(Product.country_short_name(session[:country_id])).where(:imdb_id => params[:id], :season_id => params[:season_id], :episode_id => params[:episode_id]).first
      @streaming_prefered = StreamingProduct.available.group_by_language.country(Product.country_short_name(session[:country_id])).where(:imdb_id => params[:id], :season_id => params[:season_id], :episode_id => params[:episode_id])
      @streaming_not_prefered = nil
    elsif @token_valid == true
      if Rails.env.development?
        @streaming = StreamingProduct.available_token.where(:imdb_id => params[:id], :season_id => params[:season_id], :episode_id => params[:episode_id]).first
        @streaming_prefered = StreamingProduct.available_token.group_by_language.where(:imdb_id => params[:id], :season_id => params[:season_id], :episode_id => params[:episode_id])
      else
        @streaming = StreamingProduct.available_token.country(Product.country_short_name(session[:country_id])).where(:imdb_id => params[:id], :season_id => params[:season_id], :episode_id => params[:episode_id]).first
        @streaming_prefered = StreamingProduct.available_token.group_by_language.country(Product.country_short_name(session[:country_id])).where(:imdb_id => params[:id], :season_id => params[:season_id], :episode_id => params[:episode_id])
      end
      @streaming_not_prefered = nil
    else
      @streaming = StreamingProduct.available_beta.country(Product.country_short_name(session[:country_id])).alpha.where(:imdb_id => params[:id], :season_id => params[:season_id], :episode_id => params[:episode_id]).first
      @streaming_prefered = StreamingProduct.alpha.country(Product.country_short_name(session[:country_id])).group_by_language.where(:imdb_id => params[:id], :season_id => params[:season_id], :episode_id => params[:episode_id])
      @streaming_not_prefered = nil
    end

    if @token_valid == true and @token.token.include?('hdnts')
      if @token.create_token_code(params[:id], params[:kind])
      else
        flash[:error] = t('streaming_products.tvod_no_token')
        redirect_to root_localize_path and return
      end
    end
    unless current_customer.customers_abo_payment_method == 5
      if current_customer && current_customer.tvod_only? && !(@token_valid == true || @streaming.prepaid_all? || current_customer.tvod_free >= @streaming.tvod_credits)
        flash[:error] = t('streaming_products.tvod_no_token')
        redirect_to root_localize_path and return
      end
      if current_customer && current_customer.tvod_credits? && !(@token_valid == true || @streaming.prepaid_all? || current_customer.tvod_free >= @streaming.tvod_credits || @product.svod?)
        flash[:error] = t('streaming_products.tvod_no_token')
        redirect_to root_localize_path and return
      end
    end

    if !current_customer
      if request.xhr?
        render :partial => 'streaming_products/no_player', :locals => {:token => nil, :error => Token.error[:code_expired]}, :layout => false
      else
        flash[:error] = t('streaming_products.code_expired')
        redirect_to root_localize_path and return
      end
    else
      @body_id = 'streaming'
      @vod_create_token = "1" #General.find_by_CodeType('VOD_CREATE_TOKEN').value
      @vod_disable = "1" #General.find_by_CodeType('VOD_ONLINE').value

      if !request.xhr?
        if @product
          if @vod_disable == "1"
            #if view_context.streaming_access?
            #if (current_customer.actived? && !current_customer.suspended? && (current_customer.subscription_type.packages_ids.split(',').include?(@product.package_id.to_s) || @streaming.prepaid_all?) && (@product.svod? || (@product.tvod? && current_customer.payable?) || @token_valid || current_customer.tvod_free >= @streaming.tvod_credits))
            #if !@streaming_prefered.blank? || !@streaming_not_prefered.blank?
            if @token_valid == false && @vod_create_token == "0" && Rails.env != "pre_production"
              error = t('streaming_products.not_available.offline')
              show_error(error)
            else
              render :action => :show
            end
            #else
            #  error = t('streaming_products.not_available.not_available')
            #  show_error(error)
            #end
            #else
            #  error = t('streaming_products.no_access.problem')
            #  show_error(error)
            #end
          else
            error = t('streaming_products.no_access.no_access')
            show_error(error)
          end
        else
          error = t('streaming_products.not_available.offline')
          show_error(error)
        end
        #else
        #  error = t('streaming_products.not_available.not_available')
        #  show_error(error)
        #end
      else
        if view_context.streaming_access?
          streaming_version = StreamingProduct.find_by_id(params[:streaming_product_id])
          if ((!current_customer.suspended? && !Token.dvdpost_ip?(request.remote_ip) && !(/^192(.*)/.match(request.remote_ip)) && current_customer.actived? && (current_customer.subscription_type.packages_ids.split(',').include?(@product.package_id.to_s) || @streaming.prepaid_all?) && (@product.svod? || (!@product.svod? && current_customer.payable?) || current_customer.tvod_free >= @streaming.tvod_credits)))
            #if 1==1
            status = @token.nil? ? nil : @token.current_status(request.remote_ip)
            streaming_version = StreamingProduct.find_by_id(params[:streaming_product_id])
            if !@token || status == Token.status[:expired]
              #if current_customer
              creation = Token.create_token(params[:id], @product, request.remote_ip, params[:streaming_product_id], params[:season_id], params[:episode_id], params[:kind], current_customer, params[:source])
              #send_mail = true
              #else
              #  creation = nil
              #  send_mail = false
              #end
              if creation
                @token = creation[:token]
                error = creation[:error]
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
                  if params[:kind] == :adult
                    if @product.studio
                      studio_name = @product.studio.name
                      studio_id = @product.studio.id
                    else
                      studio_name = ''
                      studio_id = ''
                    end
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
                    options = options.merge("\\$\\$\\$studio_name\\$\\$\\$" => studio_name, "\\$\\$\\$studio_slug\\$\\$\\$" => studio_id)
                  else
                    options =
                        {
                            "\\$\\$\\$customers_name\\$\\$\\$" => "#{current_customer.first_name.capitalize} #{current_customer.last_name.capitalize}",
                            "\\$\\$\\$gender_simple\\$\\$\\$" => gender,
                            "\\$\\$\\$products_id\\$\\$\\$" => product_id,
                            "\\$\\$\\$imdb_id\\$\\$\\$" => imdb_id,
                            "\\$\\$\\$image1\\$\\$\\$" => stars[0],
                            "\\$\\$\\$image2\\$\\$\\$" => stars[1],
                            "\\$\\$\\$image3\\$\\$\\$" => stars[2],
                            "\\$\\$\\$image4\\$\\$\\$" => stars[3],
                            "\\$\\$\\$image5\\$\\$\\$" => stars[4],
                            "\\$\\$\\$products_name\\$\\$\\$" => !@product.series? ? @product.title : @product.episode_title,
                            "\\$\\$\\$products_year\\$\\$\\$" => @product.year,
                            "\\$\\$\\$products_image\\$\\$\\$" => image,
                        }
                    top = Product.joins(:lists).includes("descriptions_#{I18n.locale}", 'vod_online_be').where("lists.#{I18n.locale} = 1").order("lists.id desc").limit(20)
                    index = 0
                    top.each do |top|
                      unless top.vod_online_be.size == 0
                        index = index + 1
                        options = options.merge("\\$\\$\\$products_id#{index}\\$\\$\\$" => top.id, "\\$\\$\\$products_id#{index}_img\\$\\$\\$" => top.description.image, "\\$\\$\\$products_id#{index}_name\\$\\$\\$" => top.title)
                        break if index == 4
                      end
                    end
                  end
                  unless Rails.env.development?
                    view_context.send_message(mail_id, options, params[:locale], current_customer)
                  end
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
            current_customer.remove_product_from_wishlist(params[:id], params[:season_id], params[:episode_id], request.remote_ip) if current_customer
            StreamingViewingHistory.create(:streaming_product_id => params[:streaming_product_id], :token_id => @token.to_param, :ip => request.remote_ip)
            render :partial => 'streaming_products/player', :locals => {:token => @token, :filename => streaming_version.filename, :source => streaming_version.source, :streaming => streaming_version, :browser => @browser, :season_id => params[:season_id], :episode_id => params[:episode_id] }, :layout => false
          elsif Token.dvdpost_ip?(request.remote_ip) || (current_customer && current_customer.super_user?) || (/^192(.*)/.match(request.remote_ip))
            render :partial => 'streaming_products/player', :locals => {:token => @token, :filename => streaming_version.filename, :source => streaming_version.source, :streaming => streaming_version, :browser => @browser, :season_id => params[:season_id], :episode_id => params[:episode_id]}, :layout => false
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
    params[:season_id] = params[:season_id] || 0
    params[:episode_id] = params[:episode_id] || 0
    params[:streaming_product_id] = params[:old_streaming_product_id] if params[:old_streaming_product_id]
    token = current_customer.get_token(params[:streaming_product_id], params[:season_id], params[:episode_id]) if current_customer
    token_valid = token.nil? ? false : token.validate?(request.remote_ip)
    if Rails.env != 'pre_production' && token_valid == false
      @streaming_subtitle = StreamingProduct.available.country(Product.country_short_name(session[:country_id])).by_language(params[:language_id]).where(:imdb_id => params[:streaming_product_id], :season_id => params[:season_id], :episode_id => params[:episode_id])
    elsif Rails.env != 'pre_production' && token_valid == true
      @streaming_subtitle = StreamingProduct.available_token.country(Product.country_short_name(session[:country_id])).by_language(params[:language_id]).where(:imdb_id => params[:streaming_product_id], :season_id => params[:season_id], :episode_id => params[:episode_id])
    else
      @streaming_subtitle = StreamingProduct.available_beta.country(Product.country_short_name(session[:country_id])).alpha.by_language(params[:language_id]).where(:imdb_id => params[:streaming_product_id], :season_id => params[:season_id], :episode_id => params[:episode_id])
    end
    render :partial => 'streaming_products/show/subtitles', :locals => {:streaming => @streaming_subtitle, :sample => params[:sample]}, :layout => false
  end

  def subtitle
    params[:season_id] = params[:season_id] || 0
    params[:episode_id] = params[:episode_id] || 0
    params[:streaming_product_id] = params[:old_streaming_product_id] if params[:old_streaming_product_id]
    token = current_customer.get_token(params[:streaming_product_id], params[:season_id], params[:episode_id]) if current_customer
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
    params[:season_id] = params[:season_id] || 0
    params[:episode_id] = params[:episode_id] || 0
    params[:streaming_product_id] = params[:old_streaming_product_id] if params[:old_streaming_product_id]
    token = current_customer.get_token(params[:streaming_product_id], params[:season_id], params[:episode_id]) if current_customer
    token_valid = token.nil? ? false : token.validate?(request.remote_ip)
    if Rails.env != 'pre_production' && token_valid == false
      @streaming_prefered = StreamingProduct.available.country(Product.country_short_name(session[:country_id])).where(:imdb_id => params[:streaming_product_id], :season_id => params[:season_id], :episode_id => params[:episode_id])
    elsif Rails.env != 'pre_production' && token_valid == true
      @streaming_prefered = StreamingProduct.available_token.country(Product.country_short_name(session[:country_id])).where(:imdb_id => params[:streaming_product_id], :season_id => params[:season_id], :episode_id => params[:episode_id])
    else
      @streaming_prefered = StreamingProduct.available_beta.country(Product.country_short_name(session[:country_id])).alpha.where(:imdb_id => params[:streaming_product_id], :season_id => params[:season_id], :episode_id => params[:episode_id])
    end
    render :partial => 'streaming_products/show/versions', :locals => {:version => @streaming_prefered, :source => params[:source], :response_id => params[:response_id]}
  end

  def sample
    #@body_id = 'streaming'
    #@meta_title = t("streaming_products.sample.meta_title", :default => '')
    #@meta_description = t("streaming_products.sample.meta_description", :default => '')
    #params[:id] = Moovies.data_sample[params[:kind]][:imdb_id]
    #product_id = Moovies.data_sample[params[:kind]][:product_id]
    #@product = Product.find_by_products_id(product_id)
    #@streaming_prefered = StreamingProduct.group_by_language.available.find_all_by_imdb_id(params[:id], I18n.locale)
    #@token_name = Moovies.token_sample[params[:kind]]

    #if request.xhr?
    @streaming = StreamingProduct.first
    #render json: @streaming
    #end

    #render json: @streaming
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
