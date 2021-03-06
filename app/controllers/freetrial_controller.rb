class FreetrialController < ApplicationController

  def plans

  	gon.case2FILMSFREE = "mon-compte/connectez-vous?code=2FILMSFREE" if I18n.locale == :fr
  	gon.case2FILMSFREE = "mijn-account/log-in?code=2FILMSFREE" if I18n.locale == :nl
  	gon.case2FILMSFREE = "my-account/log-in?code=2FILMSFREE" if I18n.locale == :en

  	gon.case4FILMSFREE = "mon-compte/connectez-vous?code=4FILMSFREE" if I18n.locale == :fr
  	gon.case4FILMSFREE = "mijn-account/log-in?code=4FILMSFREE" if I18n.locale == :nl
  	gon.case4FILMSFREE = "my-account/log-in?code=4FILMSFREE" if I18n.locale == :en

  	gon.case6FILMSFREE = "mon-compte/connectez-vous?code=6FILMSFREE" if I18n.locale == :fr
  	gon.case6FILMSFREE = "mijn-account/log-in?code=6FILMSFREE" if I18n.locale == :nl
  	gon.case6FILMSFREE = "my-account/log-in?code=6FILMSFREE" if I18n.locale == :en

    entxt if I18n.locale == :en
    nltxt if I18n.locale == :nl
    frtxt if I18n.locale == :fr

  end

  def entxt
    @text = "Get one month free trial Choose the plan that best suits </br> you and rent 2, 4 o 6 movies for free for a month"
  end

  def nltxt
    @text = "Geniet van een maand gratis abonnement Kies het pakket </br> dat het beste bij u past en huren 2, 4 of 6 films gratis voor 1 maand"
  end

  def frtxt
    @text = "Profitez de Choisissez le forfait qui vous convient le mieux </br> et louez 2,4, ou 6 films gratuiement pendant 1 mois"
  end

end
