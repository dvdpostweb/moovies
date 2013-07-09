class Email < ActiveRecord::Base
  self.table_name = :mail_messages
  self.primary_key = :mail_messages_id

  alias_attribute :body, :messages_html
  alias_attribute :subject, :messages_subject

  scope :by_language, lambda {|language| where(:language_id => Moovies.languages[language])}

  def short?
    length == 'SHORT'
  end
end