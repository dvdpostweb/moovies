class Faq < ActiveRecord::Base
  scope :ordered, :order => "ordered ASC"
end