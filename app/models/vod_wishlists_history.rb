# == Schema Information
#
# Table name: vod_wishlists_histories
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  imdb_id     :integer
#  source_id   :integer
#  added_at    :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class VodWishlistsHistory < ActiveRecord::Base
end
