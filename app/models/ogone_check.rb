# == Schema Information
#
# Table name: ogone_check
#
#  id                 :integer          not null, primary key
#  orderid            :string(50)       default("0"), not null
#  amount             :integer          default(0), not null
#  customers_id       :integer          default(0), not null
#  context            :string(255)      default(""), not null
#  products_id        :integer          default(0), not null
#  discount_code_id   :integer          default(0), not null
#  activation_code_id :integer          default(0), not null
#  gift_duration      :integer          default(0), not null
#  gift_firstname     :string(255)      default(""), not null
#  gift_lastname      :string(255)      default(""), not null
#  gift_message       :text             default(""), not null
#  sponsoring_email   :string(255)      default(""), not null
#  belgiqueloisirs_id :string(255)      default(""), not null
#  site               :integer          default(0), not null
#  language_id        :integer
#  imdb_id            :integer
#  season_id          :integer          default(0), not null
#  episode_id         :integer          default(0), not null
#  source_id          :integer          default(0)
#

class OgoneCheck < ActiveRecord::Base
  self.table_name = :ogone_check

  alias_attribute :product_id, :products_id

  belongs_to :customer, :foreign_key => :customers_id
  belongs_to :subscription_type, :foreign_key => :products_id
  belongs_to :product, :foreign_key => :products_id

end
