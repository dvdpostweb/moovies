# == Schema Information
#
# Table name: abo
#
#  abo_id             :integer          not null, primary key
#  customerid         :integer          default(0), not null
#  Action             :integer          default(0), not null
#  code_id            :integer
#  Date               :datetime         not null
#  product_id         :integer          default(0), not null
#  payment_method     :string(255)      default("ogone"), not null
#  privilege_notified :integer          default(0), not null
#  comment            :text             default(""), not null
#  site               :integer          default(0), not null
#

class Subscription < ActiveRecord::Base
  self.table_name = :abo
  self.primary_key = :abo_id

  alias_attribute :created_at, :Date
  alias_attribute :customer_id, :customerid
  alias_attribute :action, :Action

  def self.action
    action = OrderedHash.new
    action.push(:abo_downgrade, 25)
    action.push(:abo_upgrade, 2)
    action.push(:creation_without_promo, 1)
    action.push(:creation_with_discount, 6)
    action.push(:creation_with_activation, 8)
    action.push(:free_reconduction, 17)
    action.push(:reconduction, 7)
    action.push(:tvod_init_sub, 36)
    action.push(:reconduction_ealier, 13)

    action
  end

  scope :reconduction_ealier, where(:action => self.action[:reconduction_ealier])
  scope :recent,  lambda { where(:date => 5.days.ago.localtime..Time.now)}
  scope :reconduction,  where(:action => [7, 17])

  belongs_to :type, :class_name => 'SubscriptionType', :foreign_key => :product_id

  def self.subscription_change(current_customer, next_abo_type_id)
    new_abo = ProductAbo.find(next_abo_type_id)
    action = (current_customer.subscription_type.qty_credit > new_abo.credits ? Subscription.action[:abo_downgrade] : Subscription.action[:abo_upgrade])
    current_customer.update_attribute(:next_abo_type_id, next_abo_type_id.to_i)
    current_customer.abo_history(action, next_abo_type_id)
    new_abo
  end
end
