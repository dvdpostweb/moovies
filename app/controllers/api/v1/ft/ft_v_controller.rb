class Api::V1::Ft::FtVController < API::V1::BaseController

  def l_v
    if request.xhr?
      email = Customer.find_by_email(params[:FreeTrialLoginEmailAddress])
      if email.present?
        render json: TRUE
      else
        render json: FALSE
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def l_p_v
    if request.xhr?
      if params[:FreeTrialLoginEmailAddress].present? && params[:FreeTrialLoginEmailPassword].present?
        resource = Customer.find_for_database_authentication(email: params[:FreeTrialLoginEmailAddress])
        if resource.valid_password?(params[:FreeTrialLoginEmailPassword])
          render json: TRUE
        else
          render json: FALSE
        end
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def r_v
    if request.xhr?
      email = Customer.find_by_email(params[:FreeTrialLoginEmailAddress])
      if email.present?
        render json: FALSE
      else
        render json: TRUE
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
