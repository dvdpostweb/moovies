class Ticket < ActiveRecord::Base
  belongs_to :category_ticket
  has_many :message_tickets
  belongs_to :customer, :foreign_key => :customers_id

  def self.filter
    filter = Hash.new
    filter[:archive] = 'archive'
    filter[:archive] = 'current'
    filter
  end  

  scope :ordered, :order => 'id desc'
  scope :by_kind, lambda {|kind| where(:remove => kind)}
end