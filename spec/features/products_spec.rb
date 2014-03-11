#encoding: utf-8

require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!
describe "products" do
  describe "CREATE /products" do
    it "review a movie" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      #sign_in Customer.find(1)
      login_as(Customer.find(1), :scope => :customer)
      visit new_product_review_path(:product_id => 120171, :locale => :fr)
      find(:xpath, "//input[@id='review_rating']").set "3"
      fill_in('review_text', :with => Faker::Lorem.sentence(3) )
      click_button 'review_submit'
      page.should have_content("Your review has been saved")
    end
  end
end
