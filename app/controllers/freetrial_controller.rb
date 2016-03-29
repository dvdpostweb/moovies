class FreetrialController < ApplicationController

  def plans

  	gon.case2FILMSFREE = "mon-compte/sign_up?code=2FILMSFREE" if I18n.locale == :fr
  	gon.case2FILMSFREE = "mijn-account/sign_up?code=2FILMSFREE" if I18n.locale == :nl
  	gon.case2FILMSFREE = "my-account/sign_up?code=2FILMSFREE" if I18n.locale == :en

  	gon.case4FILMSFREE = "mon-compte/sign_up?code=4FILMSFREE" if I18n.locale == :fr
  	gon.case4FILMSFREE = "mijn-account/sign_up?code=4FILMSFREE" if I18n.locale == :nl
  	gon.case4FILMSFREE = "my-account/sign_up?code=4FILMSFREE" if I18n.locale == :en

  	gon.case6FILMSFREE = "mon-compte/sign_up?code=6FILMSFREE" if I18n.locale == :fr
  	gon.case6FILMSFREE = "mijn-account/sign_up?code=6FILMSFREE" if I18n.locale == :nl
  	gon.case6FILMSFREE = "my-account/sign_up?code=6FILMSFREE" if I18n.locale == :en

  end

end
