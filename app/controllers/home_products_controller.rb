class HomeProductsController < ApplicationController
  before_filter :authenticate

  def update
    ['be', 'nl', 'lu'].each do |country|
      [1, 2, 3].each do |locale|
        ['tvod', 'svod'].each do |kind|
          HomeProduct.kind(kind).country(country).locale(locale).ordered.each_with_index do |item, i|
            item.update_attribute(:product_id, params["#{kind}_#{locale}_#{i}"])
          end
        end
      end
    end
    redirect_to edit_home_products_path
  end

  def edit
  end
end