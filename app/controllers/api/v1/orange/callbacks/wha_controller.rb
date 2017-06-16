class Api::V1::Orange::Callbacks::WhaController < ApplicationController

  def success
    niz = params[:m].split(/;/).to_a
    if 'v=3:{c=PurchaseTypeSuccess'.in?(niz)
      if 'mp={_ap_AdditionalParameters=lnk_step4!cn_90160'.in?(niz)
        ap = niz[8].gsub!('mp={_ap_AdditionalParameters=','').split('!')
        step = "#{ap[0].gsub!('lnk_','')}"
        cn = "#{ap[1].gsub!('cn_','')}"
        #am = "#{ap[2].gsub!('am_','')}"
        customer = Customer.find(cn)
        render json: 1
        # #if customer.present?
        #   render json "!!!!"
        #   customer.customers_registration_step = 100
        #   customer.customers_abo = 1
        #   customer.customers_abo_validityto = Date.today + 1.month
        #   customer.customers_abo_payment_method = 6
        #   if customer.save(validate: false)
        #     #render json "!!!!"
        #       if customer.abo_history(7, customer.customers_abo_type, 7)
        #       abo = Subscription.find_by_customer_id(cn).last
        #       payment = Payment.new
        #         payment.payment_method = 6
        #         payment.date_added = Time.now
        #         payment.customers_id = cn
        #         payment.abo_id = abo.abo_id
        #         payment.amount = am
        #         if payment.save(validate: false)
        #           sign_in(customer)
        #           redirect_to step_path(:id => 'step4')
        #           #render json "!!!!"
        #         end
        #     end
        #   end
        #end
      end
    elsif 'v=3:{c=PurchaseTypeCancel'.in?(niz)
      render json: "Neuspesno"
    end
  end

  def cancel
    render json: params
  end
end
