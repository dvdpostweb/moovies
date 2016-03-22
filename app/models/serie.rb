# == Schema Information
#
# Table name: series
#
#  series_id      :integer          not null, primary key
#  series_name    :string(255)      default(""), not null
#  parent_id      :integer
#  series_type_id :integer
#  name_fr        :string(255)
#  name_nl        :string(255)
#  name_en        :string(255)
#

class Serie < ActiveRecord::Base
  self.primary_key = :series_id

  def name
    self["name_#{I18n.locale}"]
  end
end
