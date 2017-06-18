class Html5Controller < ApplicationController
  http_basic_authenticate_with :name => "html5", :password => "testing"
  def testing
  end
end
