#encoding: utf-8

module Moovies
  class << self
    def images_path
      'http://www.dvdpost.be/images'
    end

    def imagesx_path
      'http://www.dvdpost.be/imagesx'
    end

    def imagesx_preview_path
      'http://www.dvdpost.be/imagesx/screenshots'
    end

    def images_preview_path
      'http://www.dvdpost.be/images/screenshots'
    end

    def imagesx_trailer_path
      'http://www.dvdpost.be/imagesx/trailers'
    end

    def images_trailer_path
      'http://www.dvdpost.be/images/trailers'
    end

    def imagesx_banner_path
      'http://www.dvdpost.be/imagesx/banners'
    end

    def images_banner_path
      'http://www.dvdpost.be/images/banners'
    end

    def images_carousel_path
      "#{images_path}/landings_plush"
    end

    def images_carousel_adult_path
      "#{imagesx_path}/landings_plush"
    end

    def languages
      HashWithIndifferentAccess.new.merge({
                                              :fr => 1,
                                              :nl => 2,
                                              :en => 3
                                          })
    end

    def fb_url
      HashWithIndifferentAccess.new.merge({
                                              :fr => "https://www.facebook.com/pages/Plush-Belgique/204628663048936",
                                              :nl => "https://www.facebook.com/pages/Plush-België/357963814336167"
                                          })
    end

    def google_url
      HashWithIndifferentAccess.new.merge({
                                              :fr => "https://plus.google.com/u/0/b/103211800176547282006/103211800176547282006",
                                              :nl => "https://plus.google.com/u/0/b/107615603373625685175/107615603373625685175"
                                          })
    end

    def twitter_url
      HashWithIndifferentAccess.new.merge({
                                              :fr => "https://twitter.com/PlushBelgique",
                                              :nl => "https://twitter.com/PlushBelgie"
                                          })
    end

    def product_kinds
      HashWithIndifferentAccess.new.merge({
                                              :normal => 'DVD_NORM',
                                              :adult => 'DVD_ADULT',
                                              :subscription => 'ABO'
                                          })
    end

    def product_publics
      HashWithIndifferentAccess.new.merge({
                                              'all' => 1,
                                              '6' => 5,
                                              '10' => 6,
                                              '12' => 2,
                                              '14' => 7,
                                              '16' => 3,
                                              '18' => 4
                                          })
    end

    def local_product_publics
      product_publics.invert
    end

    def hours
      HashWithIndifferentAccess.new.merge({
                                              :adult => 48,
                                              :normal => 48,
                                          })
    end

    def customer_languages
      HashWithIndifferentAccess.new.merge({
                                              :fr => 1,
                                              :nl => 2,
                                              :en => 3
                                          })
    end

    def streaming_url
      "vod.dvdpost.be"
    end

    def actor_kinds
      HashWithIndifferentAccess.new.merge({
                                              :normal => 'DVD_NORM',
                                              :adult => 'DVD_ADULT'
                                          })
    end

    def generate_token_from_alpha(filename, kind, test)
      if kind == :adult
        time = 432000
      else
        time = 172800
      end

      url = "http://wesecure.alphanetworks.be/Webservice?method=createToken&key=acac0d12ed9061049880bf68f20519e65aa8ecb7&filename=#{filename}&lifetime=#{time}&simultIp=1&test=#{test}"
      data = open(url, :http_basic_authentication => ["dvdpost", "sup3rnov4$$"])
      node = Hpricot(data).search('//createtoken')
      if node.at('status').innerHTML == 'success'
        node.at('response').innerHTML
      else
        false
      end
    end

    def packages
      HashWithIndifferentAccess.new.merge({
                                              :unlimited => 1,
                                              :tvod => 2,
                                              :kids => 3,
                                              :adult_unlimited => 4,
                                              :adult_tvod => 5
                                          })
    end

    def product_publics
      HashWithIndifferentAccess.new.merge({
                                              'all' => 1,
                                              '6' => 5,
                                              '10' => 6,
                                              '12' => 2,
                                              '14' => 7,
                                              '16' => 3,
                                              '18' => 4
                                          })
    end

    def actor_kinds_int
      HashWithIndifferentAccess.new.merge({
                                              :normal => 1,
                                              :adult => 0
                                          })
    end

    def right
      HashWithIndifferentAccess.new.merge({
                                              :be => 'products_be_core',
                                              :lu => 'products_lu_core'
                                          })
    end

    def discount
      HashWithIndifferentAccess.new.merge({
                                              :svod_fr => 1,
                                              :svod_nl => 2,
                                              :svod_en => 3,
                                              :kid_fr => 4,
                                              :kid_nl => 5,
                                              :kid_en => 6,
                                              :adult_fr => 7,
                                              :adult_nl => 8,
                                              :adult_en => 9,
                                              :classic_adult_fr => 11,
                                              :classic_adult_nl => 12,
                                              :classic_adult_en => 13,
                                              :all_fr => 14,
                                              :all_nl => 15,
                                              :all_en => 16,
                                              :hp_top_fr_normal => 161,
                                              :hp_top_nl_normal => 162,
                                              :hp_top_en_normal => 163,
                                              :hp_bottom_fr_normal => 20,
                                              :hp_bottom_nl_normal => 21,
                                              :hp_bottom_en_normal => 22,
                                              :catalogue_fr => 151,
                                              :catalogue_nl => 152,
                                              :catalogue_en => 153,
                                              :catalogue_adult_fr => 196,
                                              :catalogue_adult_nl => 196,
                                              :catalogue_adult_en => 196,
                                              :contact_fr => 154,
                                              :contact_nl => 155,
                                              :contact_en => 156,
                                              :catalogue_show_fr => 157,
                                              :catalogue_show_nl => 158,
                                              :catalogue_show_en => 159,
                                              :catalogue_show_fr_adult => 196,
                                              :catalogue_show_nl_adult => 196,
                                              :catalogue_show_en_adult => 196,
                                              :contact_adult_fr => 196,
                                              :contact_adult_nl => 196,
                                              :contact_adult_en => 196,
                                              :hp_bottom_fr_adult => 196,
                                              :hp_bottom_nl_adult => 196,
                                              :hp_bottom_en_adult => 196,
                                              :hp_top_fr_adult => 164,
                                              :hp_top_nl_adult => 165,
                                              :hp_top_en_adult => 166,
                                              :svod_step90_fr => 73,
                                              :svod_step90_nl => 74,
                                              :svod_step90_en => 75,
                                              :adult_step90_fr => 76,
                                              :adult_step90_nl => 77,
                                              :adult_step90_en => 78,
                                              :classic_adult_step90_fr => 80,
                                              :classic_adult_step90_nl => 81,
                                              :classic_adult_step90_en => 79,
                                              :tvod_only => 128,
                                              :playstation => 246,
                                          })
    end

    def geo_country_name
      HashWithIndifferentAccess.new.merge({
                                              22 => 'be',
                                              131 => 'nl',
                                              161 => 'lu',
                                              0 => 'be'
                                          })
    end

    def super_user
      [1, 2, 61277, 61248, 1608, 1627, 61910, 131]
    end

    def dvdpost_ip
      HashWithIndifferentAccess.new.merge({
                                              :external => ['217.112.190.73', '217.112.190.101', '217.112.190.177', '217.112.190.178', '217.112.190.179', '217.112.190.180', '217.112.190.181', '217.112.190.182', '217.112.190.100', '217.112.185.121', '109.88.0.197', '109.88.0.198', '194.78.222.212', '213.181.46.204', '109.88.0.199', '91.183.57.165', '87.65.39.92', '94.139.62.121', '94.139.62.120', '94.139.62.123', '94.139.62.122'],
                                              :internal => '127.0.0.2'
                                          })
    end

    def ogone_pspid
      HashWithIndifferentAccess.new.merge({
                                              :development => 'dvdpostogonetest',
                                              :staging => 'dvdpostogonetest',
                                              :production => 'dvdpost'
                                          })
    end

    def ogone_pass
      HashWithIndifferentAccess.new.merge({
                                              :development => 'KILLBILL1$metropolis',
                                              :staging => 'KILLBILL1$metropolis',
                                              :production => 'KILLBILL'
                                          })
    end

    def ogone_url
      HashWithIndifferentAccess.new.merge({
                                              :development => 'test',
                                              :staging => 'test',
                                              :production => 'prod'
                                          })
    end

    def streaming_url
      "vod.dvdpost.be"
    end

    def token_sample
      HashWithIndifferentAccess.new.merge({
                                              :normal => '54a14d297d28e1.00140459',
                                              :adult => '54a14d58a61b30.80142899'
                                          })
    end

    def data_sample
      HashWithIndifferentAccess.new.merge({
                                              :normal => {:imdb_id => 1, :product_id => 129769},
                                              :adult => {:imdb_id => 2, :product_id => 130546}
                                          })
    end

    def hls_url(token, audio, sub)
      "http://vod.dvdpost.be/#{token}_#{audio}_#{sub}.m3u8"
    end

    def akamai_url(token, audio, sub)
      "http://akamai.dvdpost.be/#{token}_#{audio}_#{sub}.m3u8"
      #"http://vod.dvdpost.be/#{token}_#{audio}_#{sub}.m3u8"
    end

    def akamai_hls_url(imdb_id, audio, sub, hd, videoland, folder, season_id = 0, episode_id = 0)
      if season_id.to_s == '0'
        season_name = ''
      else
        season_name = "S#{sprintf '%02d', season_id}E#{sprintf '%02d', episode_id}_"
      end
      folder_path = folder.present? ? "#{folder}/" : ''
      bitrate = "800000,2200000#{hd ? ',3000000' : ''}"
      "http://homehlsvod-vh.akamaihd.net/i/#{folder_path}#{season_name}#{imdb_id}_A#{audio}_S#{sub}_,#{bitrate},.f4v.csmil/master.m3u8"
    end

    def akamai_hls_trailer_url(imdb_id, audio, sub, videoland, folder, season_id = '0', episode_id = 0)
      if season_id == '0'
        season_name = ''
      else
        season_name = "S#{season_id}E#{episode_id}_"
      end
      bitrate = "800000,2200000,3000000"
      folder_path = folder.present? ? "#{folder}/" : ''
      "http://homehlsvod-vh.akamaihd.net/i/trailers/#{folder_path}trailer_#{season_name}#{imdb_id}_A#{audio}_S#{sub}_,#{bitrate},.f4v.csmil/master.m3u8"
    end

    def verimatrix_url(token, audio, sub)
      "http://94.139.62.205/Content/HLS/VOD/Token/#{token}_#{audio}_#{sub}.m3u8"
    end

    def email
      HashWithIndifferentAccess.new.merge({
                                              :message_free => 578,
                                              :welcome => 625,
                                              :svod_normal => 615,
                                              :tvod_normal => 637,
                                              :svod_adult => 617,
                                              :tvod_adult => 618,
                                              :welcome_tvod => 634,
                                          })
    end

    def list_abo
      HashWithIndifferentAccess.new.merge({
                                              1 => [12, 15, 18, 21, 24, 1, 3],
                                              3 => [13, 16, 19, 22, 25, 3, 3],
                                              5 => [14, 17, 20, 23, 26, 3, 5],
                                              6 => [7, 8, 9, 10, 11, 1, 5],
                                              7 => [7, 8, 9, 10, 11, 12, 14],
                                              8 => [7, 8, 9, 10, 11, 15, 17],
                                              9 => [7, 8, 9, 10, 11, 18, 20],
                                              10 => [7, 8, 9, 10, 11, 21, 23],
                                              11 => [7, 8, 9, 10, 11, 24, 26],
                                              12 => [12, 15, 18, 21, 24, 12, 13],
                                              13 => [13, 16, 19, 22, 25, 13, 13],
                                              14 => [14, 17, 20, 23, 26, 13, 14],
                                              15 => [12, 15, 18, 21, 24, 15, 16],
                                              16 => [13, 16, 19, 22, 25, 16, 16],
                                              17 => [14, 17, 20, 23, 26, 16, 17],
                                              18 => [12, 15, 18, 21, 24, 18, 19],
                                              19 => [13, 16, 19, 22, 25, 19, 19],
                                              20 => [14, 17, 20, 23, 26, 19, 20],
                                              21 => [12, 15, 18, 21, 24, 21, 22],
                                              22 => [13, 16, 19, 22, 25, 22, 22],
                                              23 => [14, 17, 20, 23, 26, 22, 23],
                                              24 => [12, 15, 18, 21, 24, 24, 25],
                                              25 => [13, 16, 19, 22, 25, 25, 25],
                                              26 => [14, 17, 20, 23, 26, 25, 26],
                                          })
    end
  end
end
