# == Schema Information
#
# Table name: mail_messages
#
#  mail_messages_id :integer          default(0), not null, primary key
#  language_id      :integer          default(0), not null
#  messages_subject :integer          default(0), not null
#  messages_title   :integer          default(0), not null
#  messages_html    :integer          default(0), not null
#  comment          :integer          default(0), not null
#  newsletter       :integer          default(0), not null
#  viewable         :integer          default(0), not null
#  length           :integer          default(0), not null
#  force_copy       :integer          default(0), not null
#  category_id      :integer          default(0), not null
#  reminder         :integer          default(0), not null
#

class Email < ActiveRecord::Base
  self.table_name = :mail_messages
  self.primary_key = :mail_messages_id

  alias_attribute :body, :messages_html
  alias_attribute :subject, :messages_subject

  scope :by_language, lambda { |language| where(:language_id => Moovies.languages[language]) }

  def short?
    length == 'SHORT'
  end
end
