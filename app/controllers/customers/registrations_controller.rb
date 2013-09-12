class Customers::RegistrationsController < Devise::RegistrationsController
  
  def new
    @hide_footer = true
    @hide_menu = true
    if params[:customer] && params[:customer][:samsung]
      @samsung = params[:customer][:samsung]
    elsif params[:samsung]
      @samsung = params[:samsung]
    end
    if params[:code] || cookies[:code]
      code = params[:code] || cookies[:code]
      @discount = Discount.by_name(code).available.first
      @activation = Activation.by_name(code).available.first
      if @discount
        cookies.permanent[:code] = code
      elsif @activation
        cookies.permanent[:code] = code
      else
        @default_code = Discount.find(Moovies.discount["svod_#{I18n.locale}"]).name
        cookies.permanent[:code] = @default_code
      end
    end
    super
  end

  def create
    if params[:customer] && params[:customer][:samsung]
      @samsung = params[:customer][:samsung]
    elsif params[:samsung]
      @samsung = params[:samsung]
    end
    super
  end
  protected

  def after_inactive_sign_up_path_for(resource)
    step_path(:id => :confirm)
  end

end