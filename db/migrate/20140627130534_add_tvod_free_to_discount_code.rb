class AddTvodFreeToDiscountCode < ActiveRecord::Migration
  def change
    add_column :discount_code, :tvod_free, :integer, :default => 0
  end
end
