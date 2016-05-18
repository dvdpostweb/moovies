Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV["facebook_app_id"], ENV["facebook_app_secret"], scope: 'email', info_fields: 'email, first_name, last_name, gender'
  provider :twitter, ENV["twitter_app_id"], ENV["twitter_app_secret"]
end