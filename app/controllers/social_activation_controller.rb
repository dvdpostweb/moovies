class SocialActivationController < ApplicationController
  before_filter :authenticate_customer!

  def activate
  end
end
