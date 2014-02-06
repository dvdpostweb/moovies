require 'spec_helper'

describe HomeController do
  render_views
  before(:each) do
  end
  describe "GET 'index'" do
    it "should be successful" do
      I18n.available_locales.each do |locale|
        get 'index', :locale => locale
        response.should be_success
      end
    end
  end
  describe "GET 'index' logged" do
    it "should be successful" do
      customer = FactoryGirl.create(:customer)
      sign_in customer
      customer.confirm!
      customer.update_attribute(:customers_registration_step, 100)
      I18n.available_locales.each do |locale|
        get 'index', :locale => locale
      end
      response.should be_success
    end
  end
  
#  describe "GET 'show'" do
#    before { controller.stub(:authenticate_user!).and_return true }
#    it "should be successful" do
#      job = FactoryGirl.create(:job)
#      get :show, id: job
#      response.should be_success
#    end
#  end

end