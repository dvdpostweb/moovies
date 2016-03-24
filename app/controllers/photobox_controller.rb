class PhotoboxController < ApplicationController

  http_basic_authenticate_with name: "photobox", password: "3DbA93L0o9v66BJ", only: :plans

  def plans

  	gon.case2FILMS75 = "mon-compte/sign_up?code=2FILMS75" if I18n.locale == :fr
  	gon.case2FILMS75 = "mijn-account/sign_up?code=2FILMS75" if I18n.locale == :nl
  	gon.case2FILMS75 = "my-account/sign_up?code=2FILMS75" if I18n.locale == :en

  	gon.case4FILMS75 = "mon-compte/sign_up?code=4FILMS75" if I18n.locale == :fr
  	gon.case4FILMS75 = "mijn-account/sign_up?code=4FILMS75" if I18n.locale == :nl
  	gon.case4FILMS75 = "my-account/sign_up?code=4FILMS75" if I18n.locale == :en

  	gon.case6FILMS75 = "mon-compte/sign_up?code=6FILMS75" if I18n.locale == :fr
  	gon.case6FILMS75 = "mijn-account/sign_up?code=6FILMS75" if I18n.locale == :nl
  	gon.case6FILMS75 = "my-account/sign_up?code=6FILMS75" if I18n.locale == :en

  end

end