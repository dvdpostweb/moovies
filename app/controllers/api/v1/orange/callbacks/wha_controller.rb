class Api::V1::Orange::Callbacks::WhaController < ApplicationController

  def success
    niz = params[:m].split(/;/).to_a
    if 'v=3:{c=PurchaseTypeSuccess'.in?(niz)
      if 'mp={_ap_AdditionalParameters=lnk_step4!cn_90160'.in?(niz)
        ap = ""
        niz.each do |elem|
          if elem.to_s.include? "mp={_ap_AdditionalParameters="
            ap = elem.gsub!('mp={_ap_AdditionalParameters=','').split('!')
          end
        end
        step = "#{ap[0].gsub!('lnk_','')}"
        cn = "#{ap[1].gsub!('cn_','')}"
        if step == "step4"
          customer = Customer.find(cn)
          if customer.present?
            customer.customers_registration_step = 100
            customer.customers_abo = 1
            customer.customers_abo_validityto = Date.today + 1.month
            customer.customers_abo_payment_method = 6
            if customer.save(validate: false)
                if customer.abo_history(7, customer.customers_abo_type, 7)
                abo = Subscription.where(customerid: cn).last
                amn = Product.find_by_products_id(customer.customers_abo_type)
                payment = Payment.new
                  payment.payment_method = 6
                  payment.date_added = Time.now
                  payment.customers_id = cn
                  payment.abo_id = abo.abo_id
                  payment.amount = amn.products_price
                  payment.last_modified = Time.now
                  payment.payment_status = 2
                  payment.user_modified = 77
                  if payment.save(validate: false)
                    sign_in(customer)
                    redirect_to step_path(:id => 'step4')
                  end
              end
            end
          end
        elsif step == "movie"
          #movie_url = "#{ap[2].gsub!('movieurl_','')}"
          #payment = Payment.new
          #  payment.payment_method = 6
          #  payment.date_added = Time.now
          #  payment.customers_id = cn
          #  payment.abo_id = abo.abo_id
          #  payment.amount =
          #  payment.last_modified = Time.now
          #  payment.payment_status = 2
          #  payment.user_modified = cn
          #  if payment.save(validate: false)
          #    sign_in(customer)
          #    redirect_to movie_url
          #  end
          render json: params
        end
      end
    elsif 'v=3:{c=PurchaseTypeCancel'.in?(niz)
      render json: "Neuspesno"
    end
  end

  def cancel
    render json: params
  end
end
