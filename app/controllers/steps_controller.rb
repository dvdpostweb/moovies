class StepsController < ApplicationController
  before_filter :authenticate_customer!, :unless => :confirmation?
  before_filter :promo
  def show
    @body_id = params[:id]
    if params[:id] == 'step2'
      current_customer.build_address unless current_customer.address
      @countries = Country.all
      @hide_footer = true
      @hide_menu = true
    elsif params[:id] == 'step3'
      @hide_footer = true
      #@hide_menu = true
      gon.banc_card_error_message = t('orange.step3.banc_card_error_message')
    elsif params[:id] == 'step4'
      @new_tvod = Product.joins(:lists).includes("descriptions_#{I18n.locale}", 'vod_online_be').where("lists.#{I18n.locale} = 1").order("lists.id desc").limit(6)
    elsif params[:id] == 'old'
      @discount_svod = Discount.find(Moovies.discount["svod_step90_#{I18n.locale}"])
      #@discount_kids = Discount.find(Moovies.discount["kid_step90_#{I18n.locale}"])
      @discount_adult = Discount.find(Moovies.discount["adult_step90_#{I18n.locale}"])
      @discount_classic_adult = Discount.find(Moovies.discount["classic_adult_step90_#{I18n.locale}"])
      #@discount_all = Discount.find(Moovies.discount["all_step90_#{I18n.locale}"])
    end
  end

  def update
    if params[:id] == 'step3'
      current_customer.update_column(:customers_registration_step, 31)
    elsif params[:id] == 'invoice'
      current_customer.update_column(:customers_registration_step, 33)
    end
    redirect_after_registration(customer_path)
  end

  protected
  def confirmation?
    params[:id] == 'confirm'
  end

  def promo
    if params[:id] == 'step3'
      if current_customer.promo_type == 'D'
        @promo = Discount.find(current_customer.promo_id)
      else
        @promo = Activation.find(current_customer.promo_id)
      end
    elsif params[:id] == 'confirm'
      if cookies[:code]
        @promo = Discount.by_name(cookies[:code]).available.first
        if @promo.nil?
          @promo = Activation.by_name(cookies[:code]).available.first
        end
      end
    end
  end
end
