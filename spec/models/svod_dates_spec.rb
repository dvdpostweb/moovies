require 'spec_helper'
describe "Bla bla" do
  before :each do
    @svod = FactoryGirl.create(:svod_date)
  end

#describe SvodDates do
#  pending "add some examples to (or delete) #{__FILE__}"
#end
  describe "#new" do
    it "takes three parameters and returns a Book svod date" do
      @svod.should be_an_instance_of SvodDate
    end
  end
end