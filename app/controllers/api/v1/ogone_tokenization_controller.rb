class Api::V1::OgoneTokenizationController < ApplicationController

  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_customer!
  protect_from_forgery except: [:ogone_parameters_accepturl]

  def ogone_parameters_accepturl
    if params[:Alias_AliasId].present?
      customer = Customer.find(params[:Alias_AliasId].sub('p', ''))
      if customer.present?
        customer.step = 100
        customer.customers_abo = 1
        customer.customers_abo_validityto = Time.now + 1.month
        customer.customers_abo_payment_method = 1
        customer.ogone_card_type = params[:Card_Brand] if params[:Card_Brand].present?
        customer.ogone_card_no = params[:Card_CardNumber] if params[:Card_CardNumber].present?
        customer.ogone_exp_date = params[:Card_ExpiryDate] if params[:Card_ExpiryDate].present?
        customer.ogone_owner = params[:Card_CardHolderName] if params[:Card_CardHolderName].present?
        if customer.save(validate: false)
          if customer.abo_history(17, customer.abo_type_id, "FREE")
            redirect_to step_path(:id => 'step4', :locale => cookies[:locale])
          end
        end
      end
    end
  end

end
