class AddVisitIdProducts < ActiveRecord::Migration
  def change
    add_column :products, :visit_id, :integer
  end
end
