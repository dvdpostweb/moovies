# == Schema Information
#
# Table name: token_ips
#
#  id         :integer          not null, primary key
#  token_id   :integer
#  ip         :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class TokenIp < ActiveRecord::Base
end
