class User < ActiveRecord::Base
  attr_accessible :expires_at, :image, :name, :provider, :token, :uid
end
