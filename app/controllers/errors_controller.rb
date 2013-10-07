class ErrorsController < ApplicationController
  skip_before_filter :authenticate_user! # if using Devise
  def not_found
    @body_id = "i#{rand(5)+1}"
  end
end