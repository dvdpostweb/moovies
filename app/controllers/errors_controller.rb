class ErrorsController < ApplicationController
  skip_before_filter :authenticate_user! # if using Devise
  def not_found
  end
end