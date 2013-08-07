class InfoController < ApplicationController
  def index
    @body_id = params[:page_name]
    if params[:page_name] == 'abo'
      @discount_svod = Discount.find(Moovies.discount["svod_#{I18n.locale}"])
      @discount_kids = Discount.find(Moovies.discount["kid_#{I18n.locale}"])
      @discount_adult = Discount.find(Moovies.discount["adult_#{I18n.locale}"])
      @discount_classic_adult = Discount.find(Moovies.discount["classic_adult_#{I18n.locale}"])
      @discount_all = Discount.find(Moovies.discount["all_#{I18n.locale}"])
      @kid_visible = true
    end
  end
end
