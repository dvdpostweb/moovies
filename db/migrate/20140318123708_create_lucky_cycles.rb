class CreateLuckyCycles < ActiveRecord::Migration
  def change
    create_table :lucky_cycles do |t|
      t.boolean :canplay
      t.string :message
      t.integer :token_id
      t.integer :customer_id
      t.string :computed_hash
      t.integer :poke_counter
      t.string :firstname
      t.string :lastname
      t.string :email

      t.timestamps
    end
  end
end
