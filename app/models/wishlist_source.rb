class WishlistSource < ActiveRecord::Base
  def self.wishlist_source(params, wishlist_source)
      if wishlist_source.nil?
        wishlist_source = {}
        wl_source = WishlistSource.find(:all)
        wl_source.each do |item|
          wishlist_source[item.name.downcase.to_sym] = item.to_param
        end
      end
      if params[:view_mode] == 'recommended'
        source = wishlist_source[:recommendation]
      elsif params[:ppv] == "1"
        source = wishlist_source[:ppv]
      elsif params[:sort] == 'most_viewed' && params[:limit].to_i == 40
        source = wishlist_source[:most_viewed]
      elsif params[:sort] == 'token_month'
        source = wishlist_source[:most_viewed_vod]
      elsif params[:highlight_best_vod] == '1'
        source = wishlist_source[:prefered_vod]
      elsif params[:highlight_best] == '1'
        source = wishlist_source[:prefered]
      elsif params[:sort] == 'production_year_all'
        source = wishlist_source[:new]
      elsif params[:sort] == 'production_year_vod'
        source = wishlist_source[:new_vod]
      elsif params[:view_mode] == 'vod_recent'
        source = wishlist_source[:last_added_vod]
      elsif params[:view_mode] == 'recent'
        source = wishlist_source[:last_added]
      elsif params[:view_mode] == 'soon'
        source = wishlist_source[:soon]
      elsif params[:view_mode] == 'vod_soon'
        source = wishlist_source[:soon_vod]
      elsif params[:view_mode] == 'cinema'
        source = wishlist_source[:cinema]
      elsif params[:search]
        source = wishlist_source[:search]
      elsif params[:category_id]
        if params[:filter] == 'vod'
          source = wishlist_source[:category_vod]
        else
          source = wishlist_source[:category]
        end
      elsif params[:actor_id]
        source = wishlist_source[:actor]
      elsif params[:director_id]
        source = wishlist_source[:director]
      elsif params[:studio_id]
        source = wishlist_source[:studio]
      elsif params[:list_id] && !params[:list_id].blank?
        source = wishlist_source[:theme]
      else
        source = wishlist_source[:product_index]
      end
      source
    end
end
