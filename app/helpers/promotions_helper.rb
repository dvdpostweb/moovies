module PromotionsHelper
  def t2(name, brand)
    t(".#{name}_#{brand}", :default => '').empty? ? t(".#{name}") :  t(".#{name}_#{brand}")
  end
end
