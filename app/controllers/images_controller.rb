class ImagesController < ApplicationController
  
  def create
    if params[:images] && params[:images][:invoice] && (params[:images][:invoice].content_type.include?('image') ||  params[:images][:invoice].content_type.include?('pdf'))      
      current_customer.samsung_codes.unvalidated.last.update_column(:invoice, params[:images][:invoice].read)
      current_customer.update_column(:customers_registration_step, 33)
      Emailer.invoice(current_customer).deliver
      redirect_after_registration(customer_path(:id => current_customer))
    else
      redirect_to step_path(:id => :invoice), notice: t('images.create.not_sucess')
    end  

  end

end