class Discount < ActiveRecord::Base
  self.table_name = :discount_code
  self.primary_key = :discount_code_id
  
  alias_attribute :name,:discount_code
  alias_attribute :expire_at, :discount_validityto
  alias_attribute :step, :goto_step
  alias_attribute :type, :discount_type
  alias_attribute :value, :discount_value
  alias_attribute :duration_type, :discount_abo_validityto_type
  alias_attribute :duration_value, :discount_abo_validityto_value
  alias_attribute :recurring, :discount_recurring_nbr_of_month
  alias_attribute :credits, :abo_dvd_credit
  alias_attribute :next_discount_id, :next_discount
  alias_attribute :abo_type_id, :listing_products_allowed
  alias_attribute :next_abo_type_id, :next_abo_type
  alias_attribute :auto_stop, :abo_auto_stop_next_reconduction
  alias_attribute :promo_text_fr, :discount_text_fr
  alias_attribute :promo_text_nl, :discount_text_nl
  alias_attribute :promo_text_en, :discount_text_en
  alias_attribute :month_before_reuse, :discount_nbr_month_before_reuse
  
  scope :by_name, lambda {|name| where(:discount_code => name)}
  scope :available, lambda { where('(discount_validityto > ? or discount_validityto is null) and discount_status = 1', Time.now.to_s(:db))}
  has_one :subscription_type, :primary_key => :listing_products_allowed, :foreign_key => :products_id
  def tvod_only
    subscription_type.id == 6
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

  def promo_price
    abo_price = subscription_type.product.price.to_f
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
        else
          price = 0
      end
    price.to_f
  end

  def text(locale)
    eval "promo_text_#{locale}"
  end

end