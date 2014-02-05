require 'spec_helper'

describe "Adults" do
  describe "GET /adults" do
    it "go on adult page" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit root_path
      click_link "18+"
      click_link "I am over 18"
      page.should have_content("Discover the first")
    end
  end
end
