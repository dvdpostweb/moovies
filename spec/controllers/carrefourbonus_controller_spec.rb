require 'spec_helper'

describe CarrefourbonusController do

  describe "GET 'plans'" do
    it "returns http success" do
      get 'plans'
      response.should be_success
    end
  end

end
