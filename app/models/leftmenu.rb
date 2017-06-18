# == Schema Information
#
# Table name: leftmenu_movies_action
#
#  id          :integer          not null, primary key
#  products_id :integer
#  imdb_id     :integer
#  order       :integer
#

class Leftmenu < ActiveRecord::Base
  self.table_name = :leftmenu_movies_action
end
