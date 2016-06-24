require 'spec_helper'

describe SocialActivationController do

  describe "GET 'activate'" do
    it "returns http success" do
      get 'activate'
      response.should be_success
    end
  end

end
