class ChangeIdToCustomers < ActiveRecord::Migration
  def up
    #rename_column :customers, :id, :customers_id
  end

  def down
    #rename_column :customers, :customers_id, :id
  end
end
