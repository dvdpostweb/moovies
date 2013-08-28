class MailHistory < ActiveRecord::Base
  self.table_name = :mail_messages_sent_history
  self.primary_key = :mail_messages_sent_history_id
  belongs_to :customer,         :foreign_key => :customers_id
end