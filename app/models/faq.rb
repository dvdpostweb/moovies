# == Schema Information
#
# Table name: faqs
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  nb_questions :integer
#  active       :boolean
#  created_at   :datetime
#  updated_at   :datetime
#  ordered      :integer
#

class Faq < ActiveRecord::Base
  scope :ordered, :order => "ordered ASC"
end
