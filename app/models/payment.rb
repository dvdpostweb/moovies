# == Schema Information
#
# Table name: payment
#
#  id                   :integer          not null, primary key
#  payment_method       :integer          not null
#  date_added           :datetime         not null
#  customers_id         :integer          not null
#  abo_id               :integer
#  amount               :decimal(10, 2)   not null
#  payment_status       :integer          not null
#  batch_id             :integer
#  last_modified        :datetime         not null
#  domiciliation_number :string(45)
#  communication        :string(45)
#  user_modified        :integer
#  date_closed          :datetime
#  last_status_id       :integer
#  account_movements_id :integer
#  payment_type_id      :integer          default(1)
#

class Payment < ActiveRecord::Base
  self.table_name = :payment

  alias_attribute :customer_id, :customers_id
  alias_attribute :created_at, :date_added

  scope :recovery, where(:payment_status => [13, 14, 15, 16, 17, 10, 11, 12, 19, 20, 21, 22])
end
