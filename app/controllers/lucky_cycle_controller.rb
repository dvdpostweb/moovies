class LuckyCycleController < ApplicationController
  before_filter :authenticate_customer!
  
  def show
    @body_id = 'lucky'
    @lucky = current_customer.lucky_cycle.where(computed_hash: params[:id]).first
    if @lucky.nil?
      msg = t('lucky_cycle.show.lucky_not_found')
      logger.error(msg)
      flash[:notice] = msg
      redirect_to root_path
    end
  end
end
