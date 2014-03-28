module StreamingProductsHelper
  def flowplayer(source_file, source, streaming, token_name, browser, code = nil)
    if browser.iphone? || browser.ipad? || browser.tablet?
      audio = streaming.languages.by_language(:fr).first.short_alpha
      sub = streaming.subtitles.count > 0 ? streaming.subtitles.by_language(:fr).first.short_alpha : 'non'
      url = Moovies.hls_url(token_name, audio, sub)
      if browser.iphone? || (browser.tablet? && !browser.ipad?)
        script = <<-script
        $("#player").html("<video  width='696' height='389' src='#{url}'></video>")
        script
      else
        script = <<-script
        window.location.href ='#{url}'
        script
      end
    elsif !code.nil?
      audio = streaming.languages.by_language(:fr).first.short_alpha
            sub = streaming.subtitles.count > 0 ? streaming.subtitles.by_language(:fr).first.short_alpha : 'non'
            url = Moovies.hls_url(token_name, audio, sub)
            script = <<-script
            var parameters = {
                src: "#{url}",
                autoPlay: "true",
                verbose: true,
                controlBarAutoHide: "true",
                controlBarPosition: "bottom",
                plugin_hls: "/HLSProviderOSMF.swf"
            };


            // Embed the player SWF:	            
            swfobject.embedSWF(
      	"/GrindPlayer.swf"
      	, "player"
      	, 696
      	, 389
      	, "10.1.0"
      	, "expressInstall.swf"
      	, parameters
      	, {
                  allowFullScreen: "true",
                  wmode: "direct"
              }
      	, {
                  name: "StrobeMediaPlayback"
              }
      );
      script
    elsif streaming.drm == true
      audio = streaming.languages.by_language(:fr).first.short_alpha
      sub = streaming.subtitles.count > 0 ? streaming.subtitles.by_language(:fr).first.short_alpha : 'non'
      url = Moovies.verimatrix_url(token_name, audio, sub)
      script = url
    else
      script = <<-script
      $("#player").html("<object width='696' height='389'><param name='movie' value='http://#{Moovies.streaming_url}/StrobeMediaPlayback.swf'></param><param name='flashvars' value='src=http://#{Moovies.streaming_url}/#{token_name}_#{streaming.languages.by_language(:fr).first.short_alpha}_#{streaming.subtitles.count > 0 ? streaming.subtitles.by_language(:fr).first.short_alpha : 'non'}.f4m&loop=false&autoPlay=true&streamType=recorded&verbose=true&initialBufferTime=5&expandedBufferTime=30'></param><param name='allowFullScreen' value='true'></param><param name='allowscriptaccess' value='always'></param><embed src='http://#{Moovies.streaming_url}/StrobeMediaPlayback.swf' type='application/x-shockwave-flash' allowscriptaccess='always' allowfullscreen='true' width='696' height='389' flashvars='src=http://#{Moovies.streaming_url}/#{token_name}_#{streaming.languages.by_language(:fr).first.short_alpha}_#{streaming.subtitles.count > 0 ? streaming.subtitles.by_language(:fr).first.short_alpha : 'non'}.f4m&loop=false&autoPlay=true&streamType=recorded&verbose=true&initialBufferTime=5&expandedBufferTime=30'></embed></object>")
      script
    end
    if streaming.drm == true
      script
    else
      javascript_tag script
    end
  end

  def time_left(stream, kind)
    distance_of_time_in_hours((stream.updated_at + 48.hours), Time.now.localtime)
  end

  def distance_of_time_in_hours(from_time,to_time)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_hours = (((to_time - from_time).abs)/3600)
    if(distance_in_hours<1)
      "#{(((to_time - from_time).abs)/60).round} #{t('time.minutes')}"
    else
      distance_in_hours = distance_in_hours.round
      "#{distance_in_hours} #{distance_in_hours == 1 ? t('time.hour') : t('time.hours')}"
    end
  end

  def message_error(error)
    case error
      when Token.error[:query_rollback] then
        t('.rollback')
      when Token.error[:customer_not_activated] then
        t('.customer_not_activated')
      when Token.error[:user_suspended] then
        t('.customer_suspended')
      when Token.error[:user_holidays_suspended] then
        t('.user_holidays_suspended')
      when Token.error[:generation_token_failed] then
        t('.rollback')
    end
  end

end
