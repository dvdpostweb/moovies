class InfoController < ApplicationController
  def index
    @body_id = params[:page_name]
  end
end
