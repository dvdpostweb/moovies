class PhotoboxController < ApplicationController

	#layout :choose_layout_popac

  def plans
  	gon.case2FILMS75 = "customers/reactive?code=2FILMS75" if I18n.locale == :fr
  	gon.case2FILMS75 = "customers/reactive?code=2FILMS75" if I18n.locale == :nl
  	gon.case2FILMS75 = "customers/reactive?code=2FILMS75" if I18n.locale == :en
  	gon.case4FILMS75 = "customers/reactive?code=4FILMS75" if I18n.locale == :fr
  	gon.case4FILMS75 = "customers/reactive?code=4FILMS75" if I18n.locale == :nl
  	gon.case4FILMS75 = "customers/reactive?code=4FILMS75" if I18n.locale == :en
  	gon.case6FILMS75 = "customers/reactive?code=6FILMS75" if I18n.locale == :fr
  	gon.case6FILMS75 = "customers/reactive?code=6FILMS75" if I18n.locale == :nl
  	gon.case6FILMS75 = "customers/reactive?code=6FILMS75" if I18n.locale == :en
	end

end
