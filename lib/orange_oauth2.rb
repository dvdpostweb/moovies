require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Orange < OmniAuth::Strategies::OAuth2
      option :name, 'orange_oauth2'
      option :client_options, {
        site:          'https://api.orange.com',
        authorize_url: 'https://api.orange.com/openidconnect/fr/v1/authorize'
      }

      uid {
        raw_info['id']
      }

      info do
        {
          email: raw_info['email'],
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get('/me').parsed
      end
    end
  end
end
