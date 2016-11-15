class Api::V1::OgoneTokenizationController < ApplicationController

  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_customer!
  protect_from_forgery except: [:ogone_parameters_accepturl]

  def ogone_parameters_accepturl
    if params[:Alias_AliasId].present?
      render json: params
#      customer = Customer.find(params[:Alias_AliasId].sub('p', ''))
#      if customer.present?
#        customer.step = 100
#        customer.customers_abo = 1
#        customer.customers_abo_validityto = Time.now + 1.month
#        customer.customers_abo_payment_method = 1
#        if customer.save(validate: false)
#          redirect_to step_path(:id => 'step4')
#        end
#      end
    end
  end

end
