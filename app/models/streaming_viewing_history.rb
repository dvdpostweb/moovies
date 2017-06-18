# == Schema Information
#
# Table name: streaming_viewing_histories
#
#  id                   :integer          not null, primary key
#  streaming_product_id :integer
#  token_id             :integer
#  created_at           :datetime
#  updated_at           :datetime
#  quality              :string(4)
#  ip                   :string(255)
#

class StreamingViewingHistory < ActiveRecord::Base
end
