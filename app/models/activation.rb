# == Schema Information
#
# Table name: activation_code
#
#  activation_id                   :integer          not null, primary key
#  activation_code                 :string(50)       default(""), not null
#  activation_group                :integer          default(0), not null
#  activation_type                 :integer          default(0), not null
#  activation_value                :decimal(6, 2)    default(0.0), not null
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

class Activation < ActiveRecord::Base
  self.table_name = :activation_code
  self.primary_key = :activation_id

  alias_attribute :name,:activation_code
  alias_attribute :expire_at, :activation_code_validto_date
  alias_attribute :duration_type, :validity_type
  alias_attribute :duration_value, :validity_value
  alias_attribute :credits, :abo_dvd_credit
  alias_attribute :next_discount_id, :next_discount
  alias_attribute :abo_type_id, :activation_products_id
  alias_attribute :next_abo_type_id, :next_abo_type
  alias_attribute :auto_stop, :abo_auto_stop_next_reconduction
  alias_attribute :created_at, :activation_date
  alias_attribute :promo_text_fr, :activation_text_fr
  alias_attribute :promo_text_nl, :activation_text_nl
  alias_attribute :promo_text_en, :activation_text_en
  alias_attribute :group_id, :activation_group
  alias_attribute :payable, :activation_waranty
  alias_attribute :type, :activation_type
  alias_attribute :value, :activation_value

  has_one :subscription_type, :primary_key => :activation_products_id, :foreign_key => :products_id

  scope :by_name, lambda {|name| where(:activation_code => name)}
  scope :available, lambda {where('(activation_code_validto_date > ? or activation_code_validto_date is null) and customers_id = 0', Time.now.to_s(:db))}

  def tvod_only
    subscription_type && subscription_type.id == 6
  end

  def goto_step
    if tvod_only
      100
    else
      31
    end
  end

  def duration
    case duration_type
    when 1
      duration_value.days.from_now.localtime
    when 2
      duration_value.months.from_now.localtime
    when 3
      duration_value.year.from_now.localtime
    end
  end

  def text(locale)
    eval "promo_text_#{locale}"
  end

  def promo_price
      abo_price = subscription_type ? subscription_type.product.price.to_f : price
      case self.type
        #total = price - X%
        when 1
          price = (abo_price - (self.value / 100 * abo_price)).round(2)
        # tot = X € 
        when 2
          price = self.value
        # tot = price - X€
        when 3
          price = abo_price - self.value
      end
    price = 0 if price < 0
    price.to_f
  end
end
