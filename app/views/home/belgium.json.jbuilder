json.array!(@list) do |product|
  json.extract! product.description_data(true), :image, :title
  json.description product.description.text
  json.link product_url(product.to_param, kind: :normal)
  json.rating product.rating[:rating]
  json.categories product.categories, :categories_id, :name
  json.tvod product.tvod?
  json.price product.get_vod_online(0).first.tvod_price if product.get_vod_online(0).size > 0
  json.set! :previews do
    json.set! :preview1 do
      json.small product.preview_image(1, :normal)
      json.big product.preview_image(1, :normal, 'big')
    end
    json.set! :preview2 do
      json.small product.preview_image(2, :normal)
      json.big product.preview_image(2, :normal, 'big')
    end
    json.set! :preview3 do
      json.small product.preview_image(3, :normal)
      json.big product.preview_image(3, :normal, 'big')
    end
    json.set! :preview4 do
      json.small product.preview_image(4, :normal)
      json.big product.preview_image(4, :normal, 'big')
    end
    json.set! :preview5 do
      json.small product.preview_image(5, :normal)
      json.big product.preview_image(5, :normal, 'big')
    end
    json.set! :preview6 do
      json.small product.preview_image(6, :normal)
      json.big product.preview_image(6, :normal, 'big')
    end
  end
  json.reviews product.reviews.approved.where(:languages_id => 1).ordered("(customers_best_rating - customers_bad_rating ) DESC").limit(5), :reviews_text
end