class ProductsController < ApplicationController
  def show
    Rails.logger.debug { "@@@@@@@" }
      if params[:id]
        id = params[:id]
      else
        id = params[:product_id]
      end
      if Rails.env == "production"
        if params[:kind] == :adult
          @product = Product.adult_available.find(id)
          @rating_color = :pink
        else
          @product = Product.normal_available.find(id)
          Rails.logger.debug { "@@@#{@product.inspect}" }
          @rating_color = :white
        end
      else
        if params[:kind] == :adult
          @product = Product.find(id)
          @rating_color = :pink
        else
          @product = Product.find(id)
          @rating_color = :white
        end
      end
    
  end

end
