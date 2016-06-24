class AddProviderToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :uid, :integer
    add_column :customers, :token, :integer
    add_column :customers, :expires_at, :datetime
  end
end
