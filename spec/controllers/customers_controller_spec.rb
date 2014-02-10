require 'spec_helper'

describe CustomersController do
  render_views
  before(:each) do
  end
  describe "GET 'show'" do
    it "should be successful" do
      customer = Customer.find(1)
      sign_in customer
      get 'show', :id => customer.id, :locale => :fr
      response.should be_success
    end
  end

end