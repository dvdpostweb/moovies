class Authentication < ActiveRecord::Base
  #attr_accessible :provider, :token, :uid, :customer_id
  belongs_to :customer
end
