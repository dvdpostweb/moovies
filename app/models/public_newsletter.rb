# == Schema Information
#
# Table name: public_newsletters
#
#  id          :integer          not null, primary key
#  email       :string(255)
#  language_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class PublicNewsletter < ActiveRecord::Base
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  #has_many :public_newsletter_products
end
