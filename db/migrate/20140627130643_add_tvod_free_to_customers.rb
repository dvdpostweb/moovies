class AddTvodFreeToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :tvod_free, :integer, :default => 0
  end
end
