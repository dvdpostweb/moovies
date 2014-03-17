class SuspensionsController < ApplicationController
  before_filter :authenticate_customer!
  def new
    @already_suspended = current_customer.suspended?
    if @already_suspended
      @expiration_holidays_date = expiration_holdays_date
    else
      if suspension_count_current_year >= 3
        @too_many_suspensions = true
      else
        @too_many_suspensions = false
      end
    end
    if request.xhr?
      render :layout => false
    end
      
  end

  def create
    if !current_customer.suspended? && suspension_count_current_year < 3
      if params[:suspensions] && params[:suspensions][:duration] && params[:suspensions][:duration].to_i > 0
        duration = params[:suspensions][:duration].to_i
        current_customer.suspension_status = 1
        current_customer.subscription_expiration_date = current_customer.subscription_expiration_date + duration.days
        current_customer.save(:validate => false)
        current_customer.suspensions.create(:status => 'HOLIDAYS', :date_added => Time.now, :date_end => duration.days.from_now, :last_modified => Time.now, :user_modified => 55)
        @error = false
      else
        @error = true
      end
      if request.xhr?
        if @error == false
          render :layout => false
        else  
          render :layout => false, :status => false
        end
      end
      
    end
  end

  private
  def notify(error, url)
    begin
      Airbrake.notify(:error_message => "suspension problem : #{to_param} error #{error} url #{url}", :backtrace => $@, :environment_name => ENV['RAILS_ENV'])
    rescue => e
      logger.error("suspension problem : #{to_param} error #{error} url #{url}")
      logger.error(e.backtrace)
    end
  end

  def expiration_holdays_date
    if suspension = Suspension.holidays.find_all_by_customer_id(current_customer.to_param).last
      suspension.date_end
    end
  end

  def suspension_count_current_year
    Suspension.holidays.last_year.find_all_by_customer_id(current_customer.to_param).count
  end
end
