class Api::V1::FacebookController < ApplicationController

	def activation
		#if params[:code].present?
			cookies[:code] = params[:code]
			render json: { status: 9, message: "FACEBOOK" }
		#end
	end
end
