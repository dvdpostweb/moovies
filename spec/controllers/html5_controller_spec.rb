require 'spec_helper'

describe Html5Controller do

  describe "GET 'testing'" do
    it "returns http success" do
      get 'testing'
      response.should be_success
    end
  end

end
