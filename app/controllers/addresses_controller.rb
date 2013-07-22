class AddressesController < ApplicationController
  def edit
    @address = current_customer.address
    unless @address
      @address = Address.new
    end
    if request.xhr?
      render :layout => false
    end
  end

  def create
    @address = Address.new(params[:address].merge(:customer => current_customer))
    if @address.save
      current_customer.update_attribute(:address_id, @address.address_book_id)
      flash[:notice] = t(:address_modify)
      if request.xhr?
        render :layout => false
      else
        redirect_to customer_path(:id => current_customer.to_param)
      end
    else
      if request.xhr?
        render :action => :edit, :layout => false
      else
        render :action => :edit
      end
    end
  end
end
