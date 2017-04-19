class PhotoboxController < ApplicationController

	layout "application_old"

  def plans
  	gon.case2FILMS75 = "mon-compte/connectez-vous?code=2FILMS75" if I18n.locale == :fr
  	gon.case2FILMS75 = "mijn-account/log-in?code=2FILMS75" if I18n.locale == :nl
  	gon.case2FILMS75 = "my-account/log-in?code=2FILMS75" if I18n.locale == :en

  	gon.case4FILMS75 = "mon-compte/connectez-vous?code=4FILMS75" if I18n.locale == :fr
  	gon.case4FILMS75 = "mijn-account/log-in?code=4FILMS75" if I18n.locale == :nl
  	gon.case4FILMS75 = "my-account/log-in?code=4FILMS75" if I18n.locale == :en

  	gon.case6FILMS75 = "mon-compte/connectez-vous?code=6FILMS75" if I18n.locale == :fr
  	gon.case6FILMS75 = "mijn-account/log-in?code=6FILMS75" if I18n.locale == :nl
  	gon.case6FILMS75 = "my-account/log-in?code=6FILMS75" if I18n.locale == :en
	end

end
