class CarrefourbonusController < ApplicationController

  def plans
    gon.caseCFB2FILMS = new_customer_session_path(:code => "CFB2FILMS")
    gon.caseCFB4FILMS = new_customer_session_path(:code => "CFB4FILMS")
    gon.caseCFB6FILMS = new_customer_session_path(:code => "CFB6FILMS")
    gon.caseCFB8FILMS = new_customer_session_path(:code => "CFB8FILMS")
    gon.caseCFB10FILM = new_customer_session_path(:code => "CFB10FILM")
  end

end
