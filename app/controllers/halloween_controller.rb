class HalloweenController < ApplicationController
  def collection
    if General.where(CodeType: "LEFTMENU_ITEM_SHOW").where(CodeValue: 1).first
      @body_id = 'products_index'
      @body_class = 'reload'
      @countries = ProductCountry.visible.ordered
      @leftMenu = Leftmenu.all
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
