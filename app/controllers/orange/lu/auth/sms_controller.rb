class Orange::Lu::Auth::SmsController < ApplicationController

  def authorization
    if params[:code].present? && params[:code] == "2FILMS"
      gon.products_id = 7
      gon.orange_subscription_action = orange_lu_auth_sms_registration_path(:orange => "new_customer")
      gon.url_code = "&code=2FILMS"
    elsif params[:code].present? && params[:code] == "4FILMS"
      gon.products_id = 8
      gon.orange_subscription_action = orange_lu_auth_sms_registration_path(:orange => "new_customer")
      gon.url_code = "&code=4FILMS"
    elsif params[:code].present? && params[:code] == "6FILMS"
      gon.products_id = 9
      gon.orange_subscription_action = orange_lu_auth_sms_registration_path(:orange => "new_customer")
      gon.url_code = "&code=6FILMS"
    elsif params[:code].present? && params[:code] == "SVOD"
      gon.products_id = 1
      gon.orange_subscription_action = orange_lu_auth_sms_registration_path(:orange => "new_customer")
      gon.url_code = "&code=SVOD"
    elsif params[:code].present? && params[:code] == "SVOD_ADULT"
      gon.products_id = 5
      gon.orange_subscription_action = orange_lu_auth_sms_registration_path(:orange => "new_customer")
      gon.url_code = "&code=SVOD_ADULT"
    elsif params[:moovie_id].present?
      gon.products_id = params[:moovie_id]
      gon.orange_subscription_action = orange_lu_auth_sms_registration_path(:orange => "new_customer")
      gon.url_code = "&moovie_id=#{params[:moovie_id]}"
    else
      gon.orange_subscription_action = info_path(:page_name => t('routes.infos.params.alacarte'), :subscription_action_orange => "orange_subscription")
    end
    gon.code = params[:code]
  end

  def registration
    if params[:code].present? && params[:code] == "2FILMS"
      gon.products_id = 7
    elsif params[:code].present? && params[:code] == "4FILMS"
      gon.products_id = 8
    elsif params[:code].present? && params[:code] == "6FILMS"
      gon.products_id = 9
    elsif params[:code].present? && params[:code] == "SVOD"
      gon.products_id = 1
    elsif params[:code].present? && params[:code] == "SVOD_ADULT"
      gon.products_id = 5
    elsif params[:moovie_id].present?
      gon.products_id = params[:moovie_id]
    elsif params[:orange_luxembourg_promo_code].present?
      gon.orange_luxembourg_promo_code = params[:orange_luxembourg_promo_code]
    end
    gon.code = params[:code]
    gon.phone_number = params[:phone_number]
  end

  def download
    send_file Rails.root.join("public/orange_#{I18n.locale}.pdf"), :type => "application/pdf", :x_sendfile => true
  end

  def orange_sms_auto_login
    if request.xhr?
      phone = params[:plush_phone_number].to_s
      customer = Customer.find_by_customers_telephone(phone[1..-1])
      if customer.present?
        sign_in(customer)
        render json: {
            status: 0,
            current_customer_id: customer.customers_id
        }
      else
        render json: {
            status: 1
        }
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
