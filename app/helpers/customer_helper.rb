module CustomerHelper
  def suspended_notification(customer)
    if customer.payment_suspended?
      I18n.t('customer.cc_paymet_alert', :link => edit_customer_payment_methods_path(:customer_id => customer.to_param, :type => :credit_card_modification))
    else
      I18n.t('customer.holidays_suspended', :date => customer.suspensions.holidays.last.date_end.strftime('%d/%m/%Y'))
    end
  end
end