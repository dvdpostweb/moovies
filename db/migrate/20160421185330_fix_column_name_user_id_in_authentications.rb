class FixColumnNameUserIdInAuthentications < ActiveRecord::Migration
  def change
    rename_column :authentications, :user_id, :customer_id
  end
end
