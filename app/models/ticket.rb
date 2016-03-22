# == Schema Information
#
# Table name: tickets
#
#  id                 :integer          not null, primary key
#  customer_id        :integer
#  title              :string(255)
#  category_ticket_id :integer
#  remove             :boolean          default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#

class Ticket < ActiveRecord::Base
  belongs_to :category_ticket
  has_many :message_tickets
  belongs_to :customer, :foreign_key => :customers_id

  def self.filter
    filter = OrderedHash.new
    filter.push(:archive, 'archive')
    filter.push(:current, 'current')
    filter
  end

  scope :ordered, :order => 'id desc'
  scope :by_kind, lambda { |kind| where(:remove => kind) }
end
