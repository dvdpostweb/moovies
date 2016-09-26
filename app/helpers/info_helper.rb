module InfoHelper
  def float_html(number)
    if number.nil?
      res = ""
    else
      r = number.to_s.split(/\./)
      res = "<span class='unite'>#{r[0]}</span>"
      res += "<span class='cents'>,#{r[1]}</span>".html_safe
    end
    res.html_safe
  end

  def link_price(customer, code, abo, type)
    if customer
      text = type == 'tvod' ? t('info.index.abo.change') : t('products.show.recommendation.add')
      if current_customer.step == 90
        link_to text, promotion_canva_path(:code => code, :return_url => info_path(:page_name => t('routes.infos.params.abo')), :id => 'old'), :method => :post, :class => 'offer-film-button'
      else
        a = SubscriptionType.find(abo)
        logger.debug("#{customer.next_subscription_type.packages_ids} == #{a.packages_ids} #{type}")
        if (type == 'tvod' && customer.next_subscription_type.tvod_credits.to_i == a.tvod_credits.to_i) || (type == 'svod' && customer.next_subscription_type.packages_ids == a.packages_ids)
          "<div class='current_abo'>#{t('info.index.price_public.current_abo')}</div>".html_safe
        else
          params = customer.tvod_only? ? {:code => code} : {:abo_id => abo}
          link_to text, subscription_path(params), :method => :put, :class => 'offer-film-button'
        end
      end
    else
      link_to t('info.index.price_public.buy'), new_customer_registration_path(:code => code), :class => 'offer-film-button'
    end
  end
end
