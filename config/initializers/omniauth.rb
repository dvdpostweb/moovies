require 'orange_oauth2'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_APP_SECRET"], scope: 'email', info_fields: 'email, first_name, last_name, gender'
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"]
end
