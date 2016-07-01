class Api::V1::FacebookController < ApplicationController

	def activation
		if params[:code].present?
			cookies[:code] = params[:code]
			render json: { status: 9, message: cookies[:code] }
		end
	end
end