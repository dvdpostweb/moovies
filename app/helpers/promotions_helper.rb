module PromotionsHelper
  def t2(name, brand, options = {})
    t("#{name}_#{brand}", :default => '').empty? ? t("#{name}", options) : t("#{name}_#{brand}", options)
  end
end
