# == Schema Information
#
# Table name: mail_messages_sent_history
#
#  mail_messages_sent_history_id :integer          not null, primary key
#  date                          :datetime         not null
#  customers_id                  :integer          default(0), not null
#  mail_messages_id              :integer          default(0), not null
#  language_id                   :integer          default(0), not null
#  mail_opened                   :integer          default(0), not null
#  mail_opened_date              :datetime
#  customers_email_address       :string(70)
#  lstvariable                   :text
#

class MailHistory < ActiveRecord::Base
  self.table_name = :mail_messages_sent_history
  self.primary_key = :mail_messages_sent_history_id
  belongs_to :customer,         :foreign_key => :customers_id
end
