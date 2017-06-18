class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.references :imdb
      t.integer :recommendation_id
      t.integer :position

      t.timestamps
    end
    add_index :recommendations, :imdb_id
  end
end
