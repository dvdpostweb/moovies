class ListsController < ApplicationController
  before_filter :authenticate
  def new
  end

  def create
    10.times do |j|
      i = 9 - j
      if params["product_id_#{i}"] && !params["product_id_#{i}"].empty?
        fr = params["fr_#{i}"] || 0
        nl = params["nl_#{i}"] || 0
        en = params["en_#{i}"] || 0

        List.create(:product_id => params["product_id_#{i}"], :fr => fr, :nl => nl, :en => en)
      end
    end
    redirect_to new_list_path
  end
end