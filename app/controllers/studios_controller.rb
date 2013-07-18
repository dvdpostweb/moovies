class StudiosController < ApplicationController
  def index
    @filter = view_context.get_current_filter({})
    @countries = ProductCountry.visible.order
    @studios = Studio.by_kind(params[:kind]).ordered
    case session[:country_id]
      when 131
        @studios = @studios.vod_lux
      when 161
        @studios = @studios.vod_nl
      else
        @studios = @studios.vod_be
    end
  end
end