class CategoriesController < ApplicationController
  def index
    @body_id='categories'
    query = Category.roots.movies.vod.by_kind(params[:kind])
    @filter = view_context.get_current_filter({})
    @countries = ProductCountry.visible.order
    @categories = OrderedHash.new()
    if Moovies.packages[params[:package]] == 1 || Moovies.packages[params[:package]] == 4
      type = 'svod'
    else
      type = 'tvod'
    end
    @not_empty = Category.not_empty(session[:country_id], 'svod')
    if params[:kind] == :adult
      @categories.push(0, Category.search(:order => "name_#{I18n.locale} asc", :with => {:parent_id => 0, :type => Zlib::crc32(Moovies.product_kinds[params[:kind]]), "first_#{I18n.locale}_int" => Zlib::crc32('0')}, :without => {"#{@not_empty}" => 0}))
      ('a'..'z').each do |l|
        @categories.push(l, Category.search(:order => "name_#{I18n.locale} asc", :with => {:parent_id => 0, :type => Zlib::crc32(Moovies.product_kinds[params[:kind]]), "first_#{I18n.locale}_int" => Zlib::crc32(l.upcase)}, :without => {"#{@not_empty}" => 0}))
      end
    else

      @categories = Category.search(:order => "name_#{I18n.locale} asc", :with => {:active => 1, :parent_id => 0, :type => Zlib::crc32(Moovies.product_kinds[params[:kind]])}, :without => {"#{@not_empty}" => 0})

    end
  end
end