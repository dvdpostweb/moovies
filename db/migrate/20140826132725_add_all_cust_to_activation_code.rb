class AddAllCustToActivationCode < ActiveRecord::Migration
  def change
    add_column :activation_code, :all_cust, :boolean, :default => false
  end
end
