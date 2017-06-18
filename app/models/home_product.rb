# == Schema Information
#
# Table name: home_products
#
#  id         :integer          not null, primary key
#  product_id :integer
#  locale_id  :integer
#  kind       :string(10)       default("tvod")
#  country    :string(3)        default("be")
#  created_at :datetime
#  updated_at :datetime
#

class HomeProduct < ActiveRecord::Base
  belongs_to :product
  scope :kind, lambda { |kind| where(:kind => kind) }
  scope :country, lambda { |country| where(:country => country) }
  scope :locale, lambda { |locale_id| where(:locale_id => locale_id) }

  scope :ordered, :order => 'id desc'
  scope :limited, :limit => '8'

end
