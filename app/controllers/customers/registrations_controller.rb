class Customers::RegistrationsController < Devise::RegistrationsController
  
  def new
    @hide_footer = true
    @hide_menu = true
    if params[:code] || cookies[:code]
      code = params[:code] || cookies[:code]
      @discount = Discount.by_name(code).available.first
      @activation = Activation.by_name(code).available.first
      if @discount
        cookies.permanent[:code] = code
      elsif @activation
        cookies.permanent[:code] = code
      else
        cookies.permanent[:code] = Moovies.discount["svod_#{I18n.locale}"]
      end
    end
    super
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    step_path(:id => :confirm)
  end

end