class OgonesController < ApplicationController
  def create
    @ogone = OgoneCheck.find_by_orderid(params[:orderID])
    customer = @ogone.customer
    if customer.actived?
    else
      
      @ogone = OgoneCheck.find_by_orderid(params[:orderID])
      @product_abo = @ogone.subscription_type
      customer.update_attributes( :ogone_owner => params[:CN], :ogone_exp_date => params[:ED], :ogone_card_no => params[:CARDNO], :ogone_card_type => params[:BRAND])
      case @ogone.context
        when 'new_discount'
          if @ogone.discount_code_id > 0
            @discount = Discount.find(@ogone.discount_code_id)
            action = Subscription.action[:creation_with_discount]
            DiscountUse.create(:discount_code_id => @ogone.discount_code_id, :customer_id => customer.to_param, :discount_use_date => Time.now.localtime)
            #@discount.update_attributes(:discount_limit => @discount.discount_limit - 1)
            duration = @discount.duration
            auto_stop = @discount.auto_stop
            recurring = @discount.recurring > 0 ? @discount.recurring.months.from_now + 1.day : nil
          else
            action = Subscription.action[:creation_without_promo]
            duration = 1.month.from_now.localtime
            auto_stop = 0
            recurring = nil
          end
          
          price = @discount.subscription_type.price
          if price > 0
            abo_action = 7
            customer.payment.create(:payment_method => 1, :abo_id => customer.abo_type_id, :amount => price, :payment_status => 2, :created_at => Time.now.localtime, :last_modified => Time.now.localtime)
          else
            abo_action = 17
          end
        when 'new_activation'
          activation = Activation.find(@ogone.activation_code_id)
          action = Subscription.action[:creation_with_activation]
          price = 0
          duration = activation.duration
          auto_stop = activation.auto_stop
          recurring = 0
        	abo_action = 17
          activation.update_attributes(:created_at => Time.now.localtime.to_s(:db), :customers_id => customer.to_param)
      end
      customer.update_attributes(:customers_abo => 1, :customers_registration_step => 100,:customers_abo_payment_method => 1, :subscription_expiration_date => duration, :auto_stop => auto_stop, :customers_abo_discount_recurring_to_date => recurring)
      customer.abo_history(action, customer.next_abo_type_id)
      customer.abo_history(abo_action, customer.next_abo_type_id)
      #@ogone.product(:products_quantity => @ogone.product.products_quantity - 1)
      if customer.gender == 'm' 
        gender = t('mails.gender_male')
      else
        gender = t('mails.gender_female')
      end
      
      options = {
        "\\$\\$\\$customers_name\\$\\$\\$" => "#{customer.first_name.capitalize} #{customer.last_name.capitalize}", 
        "\\$\\$\\$email\\$\\$\\$" => "#{customer.email}",
        "\\$\\$\\$gender_simple\\$\\$\\$" => gender,
        "\\$\\$\\$promotion\\$\\$\\$" => promotion(customer)[:promo],
        "\\$\\$\\$final_price\\$\\$\\$" => price
        }
      #to do 
      #send_message(DVDPost.email[:welcome], options)
      
      #sponsor = Sponsorship.find_by_son_id(customer.to_param)
      #unless sponsor
      #  sponsor_email = SponsorshipEmail.find_by_email(customer.email)
      #  if sponsor_email
      #    father = Customer.find(sponsor_email.customers_id)
      #    if father.actived?
      #      Sponsorship.create(:created_at => Time.now.localtime, :father_id => father.to_param, :son_id => customer.to_param , :points => 0)
      #      options = {
      #        "\\$\\$\\$godfather_name\\$\\$\\$" => "#{father.first_name.capitalize} #{father.last_name.capitalize}", 
      #        "\\$\\$\\$son_name\\$\\$\\$" => "#{customer.first_name.capitalize} #{customer.last_name.capitalize}",
      #        "\\$\\$\\$godfather_point\\$\\$\\$" => father.inviation_points
      #        }
      #        send_message(DVDPost.email[:sponsorships_son], options, father)
      #    end
      #  end
      #end  
    end
    redirect_to step_path(:page_name => 'step4')
  end
end