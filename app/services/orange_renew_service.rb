class OrangeRenewService

  CUSTOMERS_REGISTRATION_STEP = 100
  CUSTOMERS_ABO = 1
  ACTIVATION_DISCOUNT_CODE_TYPE = "D"
  CUSTOMERS_ABO_PAYMENT_METHOD = 5

  def initialize(params)
    @discount = Discount.by_name(params[:discount]).available.first
    @customer = Customer.find(params[:customer])
  end

  def perform
    orange_purchase
  end

  private

  def orange_purchase
    orange_purchase_wcf_service = HTTParty.get("https://www.plush.be:2355/wcfservice/http/OrangePurchase?customersId=#{@customer.customers_id}&mobileNumber=#{@customer.customers_telephone}&price=0&products_id=#{@discount.listing_products_allowed}&message=subscription_renewal&payment_id=0&locale=#{I18n.locale}")
    if orange_purchase_wcf_service.parsed_response == "TRUE"
      customer_setup
    else
      orange_purchase_wcf_service
    end
  end

  def customer_setup
    begin
      @customer.customers_registration_step = CUSTOMERS_REGISTRATION_STEP
      @customer.customers_abo = CUSTOMERS_ABO
      @customer.customers_abo_type = @discount.listing_products_allowed
      @customer.customers_next_abo_type = @discount.next_abo_type
      @customer.activation_discount_code_type = ACTIVATION_DISCOUNT_CODE_TYPE
      @customer.tvod_free = @customer.tvod_free + @discount.tvod_free
      @customer.customers_abo_payment_method = CUSTOMERS_ABO_PAYMENT_METHOD
      @customer.customers_abo_validityto = Time.now + 1.month
      @customer.save(validate: false)
    rescue
      false
    end
  end

end
