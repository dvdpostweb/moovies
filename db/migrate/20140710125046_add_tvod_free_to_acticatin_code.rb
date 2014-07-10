class AddTvodFreeToActicatinCode < ActiveRecord::Migration
  def change
    add_column :activation_code, :tvod_free, :integer, :default => 0
  end
end
