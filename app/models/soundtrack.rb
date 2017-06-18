# == Schema Information
#
# Table name: products_soundtracks
#
#  soundtracks_id          :integer          default(0), not null, primary key
#  language_id             :integer          default(0), not null
#  soundtracks_description :string(50)       default(""), not null
#

class Soundtrack < ActiveRecord::Base

  self.table_name = :products_soundtracks

  self.primary_key = :soundtracks_id

  alias_attribute :name, :soundtracks_description

  has_and_belongs_to_many :products, :join_table => :products_to_soundtracks, :foreign_key => :products_soundtracks_id, :association_foreign_key => :products_id

end
