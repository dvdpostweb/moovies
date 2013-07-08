class MessageTicket < ActiveRecord::Base
  belongs_to :ticket
  has_many :emails, :foreign_key => :mail_messages_id, :primary_key => :mail_id
  scope :unread, where("`is_read` = 0 and user_id > 0")
  scope :custer, where("user_id > 0")
  scope :ordered, :order => "id DESC"
  
  def unread?
    is_read == 0 && !user_id.nil?
  end
end