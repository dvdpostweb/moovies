class HomeProduct < ActiveRecord::Base
  belongs_to :product
  scope :kind, lambda {|kind| where(:kind => kind)}
  scope :country, lambda {|country|  where(:country => country)}
  scope :locale, lambda {|locale_id|  where(:locale_id => locale_id)}

  scope :ordered, :order => 'id desc'
  scope :limited, :limit => '8'

end
