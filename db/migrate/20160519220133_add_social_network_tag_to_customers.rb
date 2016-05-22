class AddSocialNetworkTagToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :social_network_tag, :string
  end
end
