# == Schema Information
#
# Table name: tokens_trailers
#
#  id         :integer          not null, primary key
#  token      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  expire_at  :datetime
#  imdb_id    :integer
#  active     :boolean
#  filename   :string(255)
#

class TokensTrailer < ActiveRecord::Base
  scope :available, lambda { where('active = ? and expire_at > ?', 1, Time.now) }

end
