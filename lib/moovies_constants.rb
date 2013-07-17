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
    
  end
end
