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
      "#{images_path}/landings"
    end

    def images_carousel_adult_path
      "#{imagesx_path}/landings"
    end

    def languages
      HashWithIndifferentAccess.new.merge({
        :fr => 1,
        :nl => 2,
        :en => 3
      })
    end

    def email
      HashWithIndifferentAccess.new.merge({
        :sponsorships_invitation    => 446,
        :sponsorships_son           => 447,
        :streaming_product          => 571,
        :streaming_product_free     => 585,
        :message_free               => 578,
        :welcome                    => 556,
        :lavenir                   => 560
      })
    end

    def fb_url
      HashWithIndifferentAccess.new.merge({
        :fr => "http://www.facebook.com/",
        :nl => "http://www.facebook.com/",
        :en => "http://www.facebook.com/"
      })
    end

    def twitter_url
      "http://twitter.com/"
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
       :hp_top_fr => 17,
       :hp_top_nl => 18,
       :hp_top_en => 19,
       :hp_bottom_fr => 20,
       :hp_bottom_nl => 21,
       :hp_bottom_en => 22,
      })
    end
  end
  def geo_country_name
    HashWithIndifferentAccess.new.merge({
     22 => 'be',
     131 => 'nl',
     161 => 'lu',
     0 => 'be'
    })
  end
end
