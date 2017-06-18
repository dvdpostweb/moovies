class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :name
      t.integer :canva_id
      t.text :params

      t.timestamps
    end
  end
end
