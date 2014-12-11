class CreateRestaurantCuisines < ActiveRecord::Migration
  def change
    create_table :restaurant_cuisines do |t|
      t.integer :restaurant_id
      t.integer :cuisine_id

      t.timestamps
    end
    add_index :restaurant_cuisines, :restaurant_id
    add_index :restaurant_cuisines, :cuisine_id
  end
end
