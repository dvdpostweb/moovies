class AddKeyInPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :key, :string
  end

end
