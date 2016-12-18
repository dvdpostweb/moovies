class StopController < ApplicationController

  def show_msg
    if request.xhr?
      render :layout => false
    end
  end

end
