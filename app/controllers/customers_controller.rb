class CustomersController < ApplicationController
  before_filter :authenticate_customer!
  def index
    redirect_to customer_path(:id => current_customer)
  end
  def show
    @body_id = 'moncompte'
    @customer = current_customer
    @streaming_available = current_customer.get_all_tokens
    @review_count = current_customer.reviews.approved.joins(:product).where(:products => {:products_type => Moovies.product_kinds[params[:kind]], :products_status => [-2,0,1]}).count
   
  end

  def edit
    @customer = current_customer
    if request.xhr?
      render :layout => false
    end
  end

  def update
    current_customer.build_address unless current_customer.address
    
    if params[:customer][:address_attributes]
      params[:customer][:address_attributes][:first_name] = params[:customer][:first_name]
      params[:customer][:address_attributes][:last_name] = params[:customer][:last_name]
      params[:customer][:address_attributes][:gender] = params[:customer][:gender]
      params[:customer][:address_attributes][:customers_id] = current_customer.to_param
    end
    @customer = current_customer
    if @customer.update_attributes(params[:customer])
      flash[:notice] = t(:customer_modify)
      if current_customer.step == 31
        current_customer.update_column(:customers_registration_step, 33)
      end
      if request.xhr?
        render :layout => false
      else
        redirect_after_registration(customer_path)
      end
    else  
      @countries = Country.all
      if request.xhr?
        render :action => :edit, :layout => false
      else
        if current_customer.step == 31
          render :template => "steps/index", :locals => {:id => 'step2'}
        elsif current_customer.step == 33
          render :template => "steps/index", :locals => {:id => 'step3'}
        end
      end
    end
  end

  def newsletter
    @customer = current_customer
    @customer.newsletter!(params[:type], params[:value])
    if params[:type] == 'newsletter'
      data = @customer.newsletter
    else
      data = @customer.newsletter_parnter
    end
    if request.xhr?
      render :partial => 'customers/show/active', :locals => {:active => data, :type => params[:type]}
    else
      redirect_to customer_path(:id => current_customer.to_param)
    end
  end
  
  def newsletters_x
    #to do
    @customer = current_customer
    @customer.update_attribute(:newsletters_x, params[:value])
    respond_to do |format|
      format.html do
        redirect_to customer_path(:id => current_customer.to_param)
      end
      format.js {render :partial => 'customers/show/newsletters_x', :locals => {:newsletters_x => @customer.newsletters_x}}
    end
  end
  
  def newsletter_x
    respond_to do |format|
      format.html 
      format.js {render :layout => false}
    end
  end
  
  def sexuality
    @customer = current_customer
    @customer.update_attribute(:sexuality, params[:value])
    session[:sexuality] = params[:value].to_i
    redirect_to root_path
  end

  def unsubscribe
    if params[:type] == 'profile_part'
      customer = Customer.find_by_email(params[:email])
      if customer
        customer.update_attribute(:newsletter_parnter, false)
      end
      vision = EmailVisionCustomer.find_by_email(params[:email])
      if vision
        vision.update_attribute(:newsletters_partners, false)
      end
      
    end
  end
end
