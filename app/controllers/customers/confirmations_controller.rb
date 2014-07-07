class Customers::ConfirmationsController < Devise::ConfirmationsController
  
  private

    def after_confirmation_path_for(resource_name, resource)
      if resource.step == 100
        top = Product.joins(:lists).includes("descriptions_#{I18n.locale}", 'vod_online_be').where("lists.#{I18n.locale} = 1").order("lists.id desc").limit(20)
        options = {}
        index = 0 
        top.each do |top|
          unless top.vod_online_be.size == 0
            index = index + 1
            options = options.merge("\\$\\$\\$products_id#{index}\\$\\$\\$" => top.id, "\\$\\$\\$products_id#{index}_img\\$\\$\\$" => top.description.image, "\\$\\$\\$products_id#{index}_name\\$\\$\\$" => top.title)
            break if index == 4
          end
        end
        view_context.send_message(Moovies.email[:welcome_tvod], options, params[:locale], current_customer)
        if cookies[:imdb_id]
          product = Product.where(:imdb_id => cookies[:imdb_id]).first
          cookies.delete :imdb_id
          if product
            product_path(:id => product.to_param)
          else
            step_path(:id => 'step4')
          end
        else
          step_path(:id => 'step4')
        end
      else
        step_path(:id => 'step2')
      end
    end
end