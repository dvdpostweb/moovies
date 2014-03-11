require 'spec_helper'

describe InfoController do
  render_views
  describe "GET 'abo'" do
    it "should be successful" do
      get 'index', :page_name => :abo, :locale => :fr
      response.should be_success
    end
  end
  describe "GET 'abo'" do
    it "should be successful" do
      get 'index', :page_name => I18n.t('routes.infos.params.abo'), :locale => :fr
      response.should be_success
    end
  end
  describe "GET 'vod'" do
    it "should be successful" do
      get 'index', :page_name => I18n.t('routes.infos.params.vod'), :locale => :fr
      response.should be_success
    end
  end
  describe "GET 'whoweare'" do
    it "should be successful" do
      get 'index', :page_name => I18n.t('routes.infos.params.whoweare'), :locale => :fr
      response.should be_success
    end
  end
  describe "GET 'privacy'" do
    it "should be successful" do
      get 'index', :page_name => I18n.t('routes.infos.params.privacy'), :locale => :fr
      response.should be_success
    end
  end
  describe "GET 'conditions'" do
    it "should be successful" do
      get 'index', :page_name => I18n.t('routes.infos.params.conditions'), :locale => :fr
      response.should be_success
    end
  end
  describe "GET 'get_connected'" do
    it "should be successful" do
      get 'index', :page_name => I18n.t('routes.infos.params.get_connected'), :locale => :fr
      response.should be_success
    end
  end
end
