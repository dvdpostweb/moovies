class Api::V1::Orange::Callbacks::WhaController < ApplicationController

  #def success3
  #  niz = params[:m].split(/;/).to_a
  #  if 'v=3:{c=PurchaseTypeSuccess'.in?(niz)
  #    niz = params[:m].split(/;/).to_a
  #  elsif 'v=3:{c=PurchaseTypeCancel'.in?(niz)
  #    render json: "Neuspesno"
  #  end
  #end

  #def success1
  #   niz = params[:m].split(/;/).to_a
  #   render json: niz
  #end

  def success
    niz = params[:m].split(/;/).to_a
    if 'v=3:{c=PurchaseTypeSuccess'.in?(niz)
      stepis =""
      niz.each do |elemm|
        if elemm.to_s.include? "ap_AdditionalParameters=lnk_step4"
          stepis="step4"
        elsif elemm.to_s.include? "ap_AdditionalParameters=lnk_movie"
          stepis="movie"
        end
      end
      ap = ""
      niz.each do |elem|
        if elem.to_s.include? "_ap_AdditionalParameters="
          ap = elem.gsub!('_ap_AdditionalParameters=','').split('!')
        end
      end
      step = "#{ap[0].gsub!('lnk_','')}"
      cn = "#{ap[1].gsub!('cn_','')}"

      if stepis=="step4"
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
      elsif stepis == "movie"

          movie_url = "#{ap[2].gsub!('movieurl_','')}"

          customer = Customer.find(cn)
          if customer.present?
            customer.customers_registration_step = 100
            customer.customers_abo = 1
            customer.customers_abo_payment_method = 6
            customer.customers_abo_type = 6
            if customer.save(validate: false)
                if customer.abo_history(7, customer.customers_abo_type, 7)
                abo = Subscription.where(customerid: cn).last
                amn = Product.find_by_products_id(movie_url)
                streaming = StreamingProduct.find_by_imdb_id(amn.imdb_id)
                payment = Payment.new
                  payment.payment_method = 6
                  payment.date_added = Time.now
                  payment.customers_id = cn
                  payment.abo_id = abo.abo_id
                  payment.amount = streaming.tvod_price
                  payment.last_modified = Time.now
                  payment.payment_status = 2
                  payment.user_modified = 77
                  if payment.save(validate: false)
                    sign_in(customer)
                    redirect_to streaming_product_path(:id => amn.imdb_id, :season_id => amn.season_id, :episode_id => amn.episode_id)
                  end
              end
            end
          end
      end
    elsif 'v=3:{c=PurchaseTypeCancel'.in?(niz)
      redirect_to root_localize_path
    end
  end

  def cancel
    redirect_to root_localize_path
  end
end
