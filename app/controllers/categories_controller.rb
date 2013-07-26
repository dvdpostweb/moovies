class CategoriesController < ApplicationController
  def index
    query = Category.roots.movies.vod.by_kind(params[:kind])
    @filter = view_context.get_current_filter({})
    @countries = ProductCountry.visible.order
    @categories = OrderedHash.new()
    if params[:kind] == :adult
      @categories.push(0, query.joins(:descriptions).where('categories_description.categories_name REGEXP "^[0-9]" and language_id = ?', Moovies.languages[I18n.locale]))
      ('a'..'z').each do |l|
        @categories.push(l, query.alphabetic_orderd.joins(:descriptions).where('categories_description.categories_name like ? and language_id = ?', l+'%', Moovies.languages[I18n.locale]))
      end
    else
      @categories = query.active.alphabetic_orderd.joins(:descriptions).where('language_id = ?', Moovies.languages[I18n.locale])
    end
  end
end