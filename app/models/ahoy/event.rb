# == Schema Information
#
# Table name: ahoy_events
#
#  id         :integer          not null, primary key
#  visit_id   :integer
#  user_id    :integer
#  name       :string(255)
#  properties :text
#  time       :datetime
#  country    :string(255)
#

module Ahoy
  class Event < ActiveRecord::Base
    include Ahoy::Properties

    self.table_name = "ahoy_events"

    belongs_to :visit
    belongs_to :user, class_name: "Customer"

    serialize :properties, JSON
  end
end
