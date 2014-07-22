class Serie < ActiveRecord::Base
  self.primary_key = :series_id

  def name
    self["name_#{I18n.locale}"]
  end
end
