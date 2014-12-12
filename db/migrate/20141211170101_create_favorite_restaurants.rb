class CreateFavoriteRestaurants < ActiveRecord::Migration
  def change
    create_table :favorite_restaurants do |t|
      t.integer :user_id
      t.integer :restaurant_id
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :favorite_restaurants, :user_id
    add_index :favorite_restaurants, :restaurant_id
    add_index :favorite_restaurants, :archived
  end
end
