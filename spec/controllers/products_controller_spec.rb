require 'spec_helper'

describe ProductsController do
  render_views
  describe "GET 'index'" do
    it "should be successful" do
      get 'index', :locale => :fr
      response.should be_success
    end
  end
  describe "GET 'index svod new'" do
    it "should be successful" do
      get 'index', :locale => :fr, :package => "vod-illimitee", :view_mode => "svod_new"
      response.should be_success
    end
  end
  describe "GET 'index svod most view'" do
    it "should be successful" do
      get 'index', :locale => :fr, :package => "vod-illimitee", :view_mode => "most_viewed"
      response.should be_success
    end
  end
  describe "GET 'index tvod tvod_soon'" do
     it "should be successful" do
       get 'index', :locale => :fr, :package => "pay-per-view", :view_mode => "tvod_soon"
       response.should be_success
     end
   end
   describe "GET 'index tvod tvod_last_chance'" do
     it "should be successful" do
       get 'index', :locale => :fr, :package => "pay-per-view", :view_mode => "tvod_last_chance"
       response.should be_success
     end
   end
   describe "GET 'index tvod adult'" do
      it "should be successful" do
        session[:adult] = 1
        get 'index', :locale => :fr, :package => "adult_tvod", :kind => "adult"
        response.should be_success
      end
    end

   describe "GET 'show random" do
     it "should be successful" do
       get 'show', :locale => :fr, :id => Product.order('rand()').first
       response.should be_success
     end
   end
  
end
