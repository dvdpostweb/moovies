class Customers::SessionsController < Devise::SessionsController
  def new
    @meta_title = t("sessions.new.meta_title", :default => '')
    @meta_description = t("sessions.new.meta_description", :default => '')
    super
  end
  
  def create
    @meta_title = t("sessions.new.meta_title", :default => '')
    @meta_description = t("sessions.new.meta_description", :default => '')
    super
  end
end