# == Schema Information
#
# Table name: activation_code
#
#  activation_id                   :integer          not null, primary key
#  activation_code                 :string(50)       default(""), not null
#  activation_group                :integer          default(0), not null
#  activation_type                 :integer
#  activation_value                :decimal(6, 2)
#  campaign_id                     :integer          not null
#  activation_group_id             :integer          default(0), not null
#  activation_pack                 :integer          default(0), not null
#  activation_code_creation_date   :datetime         not null
#  activation_code_validto_date    :datetime
#  activation_products_id          :integer          default(0), not null
#  validity_month                  :integer          default(0), not null
#  validity_type                   :integer          default(2), not null
#  validity_value                  :integer          default(1), not null
#  activation_waranty              :integer          default(0), not null
#  customers_id                    :integer          default(0)
#  activation_date                 :datetime
#  comment                         :string(50)       default(""), not null
#  next_discount                   :integer          default(0), not null
#  credit0_auto_reconduct          :integer          default(0), not null
#  abo_auto_stop_next_reconduction :integer          default(0), not null
#  banner                          :string(45)       default("4dvd.gif"), not null
#  activation_text_fr              :string(70)       default(""), not null
#  activation_text_nl              :string(70)       default(""), not null
#  activation_text_en              :string(70)       default(""), not null
#  free_upgrade_allowed            :integer          default(0), not null
#  footer                          :string(50)       default("FREETRIAL"), not null
#  campaign                        :string(60)       not null
#  combined_action                 :string(3)        default("NO")
#  next_abo_type                   :integer
#  paypal                          :integer          default(0)
#  creditcard                      :integer          default(0)
#  debitcard                       :integer          default(0)
#  discount_action                 :string(9)        default("")
#  tvod_free                       :integer          default(0)
#  all_cust                        :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Activation, :type => :model do

end
