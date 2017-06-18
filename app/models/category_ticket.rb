# == Schema Information
#
# Table name: category_tickets
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  reminder   :boolean          default(FALSE)
#

class CategoryTicket < ActiveRecord::Base
  has_many :tickets
end
