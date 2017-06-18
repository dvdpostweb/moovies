# == Schema Information
#
# Table name: authentications
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  provider    :string(255)
#  uid         :string(255)
#  token       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  email       :string(255)
#

class Authentication < ActiveRecord::Base
  #attr_accessible :provider, :token, :uid, :customer_id
  belongs_to :customer
end
