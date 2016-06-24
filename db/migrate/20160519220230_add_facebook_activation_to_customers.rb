class AddFacebookActivationToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :facebook_activation, :integer
  end
end
