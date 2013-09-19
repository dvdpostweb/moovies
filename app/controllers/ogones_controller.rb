class OgonesController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def create
    if params[:skip] 
      customer = current_customer
      if current_customer.promo_type == 'D'
        @promo = Discount.find(current_customer.promo_id)
        discount_code_id = @promo.id
        context = 'new_discount'
      else
        @promo = Activation.find(current_customer.promo_id)
        context = 'new_activation'
      end
      if @promo.promo_price > 0 && @promo.payable != 2
        return false
      end
    else
      @ogone = OgoneCheck.find_by_orderid(params[:orderID])
      customer = @ogone.customer
      context = @ogone.context
      if context == 'new_discount'
        discount_code_id = @ogone.discount_code_id
      end
    end
    if customer.actived?
    else
      if params[:skip]
      else
        customer.update_attributes(:customers_abo_payment_method => 1, :ogone_owner => params[:CN], :ogone_exp_date => params[:ED], :ogone_card_no => params[:CARDNO], :ogone_card_type => params[:BRAND])
      end
      
      case context
        when 'new_discount'
          if customer.promo_id > 0
            @discount = Discount.find(customer.promo_id)
            @promo = @discount
            action = Subscription.action[:creation_with_discount]
            DiscountUse.create(:discount_code_id => discount_code_id, :customer_id => customer.to_param, :discount_use_date => Time.now.localtime)
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
          
          price = @discount.promo_price
          if price > 0
            abo_action = 7
          else
            abo_action = 17
          end
          abo = customer.abo_history(abo_action, customer.next_abo_type_id)
          customer.payment.create(:payment_method => 1, :abo_id => abo.id, :amount => price, :payment_status => 2, :created_at => Time.now.localtime, :last_modified => Time.now.localtime) if price > 0
        when 'new_activation'
          activation = Activation.find(current_customer.promo_id)
          @promo = activation
          action = Subscription.action[:creation_with_activation]
          price = 0
          duration = activation.duration
          auto_stop = activation.auto_stop
          recurring = 0
        	abo_action = 17
          activation.update_attributes(:created_at => Time.now.localtime.to_s(:db), :customers_id => customer.to_param)
          customer.abo_history(abo_action, customer.next_abo_type_id)
          
      end
      if customer.samsung_codes.unvalidated.empty?
        cust_abo = 1
      else
        cust_abo = 1
      end
      customer.update_attributes(:customers_abo => cust_abo, :customers_registration_step => 100, :subscription_expiration_date => duration, :auto_stop => auto_stop, :customers_abo_discount_recurring_to_date => recurring)
      customer.abo_history(action, customer.next_abo_type_id)
      
      if customer.gender == 'm' 
        gender = t('mails.gender_male')
      else
        gender = t('mails.gender_female')
      end
      #to do
      options = {
        "\\$\\$\\$customers_name\\$\\$\\$" => "#{customer.first_name.capitalize} #{customer.last_name.capitalize}", 
        "\\$\\$\\$email\\$\\$\\$" => "#{customer.email}",
        "\\$\\$\\$gender_simple\\$\\$\\$" => gender,
        "\\$\\$\\$promotion\\$\\$\\$" => @promo.text(customer.locale).html_safe,
        "\\$\\$\\$subscription\\$\\$\\$" => customer.subscription_type.description,
        "\\$\\$\\$root_url\\$\\$\\$" => root_url(:locale => nil)
        }
      view_context.send_message(Moovies.email[:welcome], options, params[:locale], customer)
      #to do 
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
    locale = customer.locale || :fr
    redirect_to step_path(:id => 'step4', :locale => locale)
  end
end