class InfoController < ApplicationController

  def index

    #if customer_signed_in? && current_customer.facebook_activation == 0
    #  gon.facebook = "neactive"
    if customer_signed_in? && params[:page_name] == t('routes.infos.params.alacarte')
      gon.alacarte = "alacarte"
      gon.subscription_action = params[:subscription_action] if params[:subscription_action].present?
    elsif customer_signed_in? && params[:page_name] == t('routes.infos.params.abo')
      gon.abo = "abo"
      gon.subscription_action = params[:subscription_action] if params[:subscription_action].present?
    elsif customer_signed_in? && params[:page_name] == t('routes.infos.params.unlimited')
      gon.unlimited = "unlimited"
      gon.subscription_action = params[:subscription_action] if params[:subscription_action].present?
    elsif customer_signed_in? && params[:page_name] == t('routes.infos.params.adult')
      gon.adult = "adult"
      gon.subscription_action = params[:subscription_action] if params[:subscription_action].present?
    #elsif params[:page_name] == t('routes.infos.params.freetrial')
    #  gon.freetrial = "freetrial"
    elsif params[:page_name] == t('routes.infos.params.alacarte')
      gon.promotion_code_message = t('session.error_alreadyused_code')
      gon.alacarte = "alacarte_not_signed_in"
    elsif params[:page_name] == t('routes.infos.params.abo')
      gon.abo = "abo_not_signed_in"
    end

    if params[:page_name] == t('routes.infos.params.vod')
      params[:page_name] = 'vod'
    elsif params[:page_name] == t('routes.infos.params.abo')
      params[:page_name] = 'abo'
    elsif params[:page_name] == t('routes.infos.params.whoweare')
      params[:page_name] = 'whoweare'
    elsif params[:page_name] == t('routes.infos.params.privacy')
      params[:page_name] = 'privacy'
    elsif params[:page_name] == t('routes.infos.params.conditions')
      params[:page_name] = 'conditions'
    elsif params[:page_name] == t('routes.infos.params.get_connected')
      params[:page_name] = 'get_connected'
    elsif params[:page_name] == t('routes.infos.params.playstation')
      params[:page_name] = 'playstation'
    end
    @meta_title = t("info.index.#{params[:page_name]}.meta_title", :default => '')
    @meta_description = t("info.index.#{params[:page_name]}.meta_description", :default => '')
    @body_id = params[:page_name]
    if params[:page_name] == 'abo'
      @discount_svod = Discount.find(Moovies.discount["svod_#{I18n.locale}"])
      @discount_kids = Discount.find(Moovies.discount["kid_#{I18n.locale}"])
      @discount_adult = Discount.find(Moovies.discount["adult_#{I18n.locale}"])
      @discount_classic_adult = Discount.find(Moovies.discount["classic_adult_#{I18n.locale}"])
      @discount_all = Discount.find(Moovies.discount["all_#{I18n.locale}"])
      @discount_tvod_only = Discount.find(Moovies.discount['tvod_only'])
    elsif params[:page_name] == 'playstation'
      @discount = Discount.find(Moovies.discount["playstation"])
    end
  end

end
