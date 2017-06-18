class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.references :product
      t.boolean :fr
      t.boolean :nl
      t.boolean :en

      t.timestamps
    end
    add_index :lists, :product_id
  end
end
