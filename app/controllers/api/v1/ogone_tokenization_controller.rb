class Api::V1::OgoneTokenizationController < ApplicationController

  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_customer!
  protect_from_forgery except: [:ogone_parameters_accepturl, :ogone_parameters_exceptionurl]

  def ogone_parameters_accepturl
    if params[:Alias_AliasId].present?
      customer = Customer_find(params[:Alias_AliasId].sub('p', ''))
      if customer.present?
        render json:customer
      end
    end
  end

  def ogone_parameters_exceptionurl
    locale = customer.locale || :fr
    redirect_to step_path(:id => 'step3', :locale => locale)
  end

end
