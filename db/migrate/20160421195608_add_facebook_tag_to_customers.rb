class AddFacebookTagToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :facebook_tag, :string
  end
end
