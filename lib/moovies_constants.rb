module Moovies
  class << self

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

  end
end