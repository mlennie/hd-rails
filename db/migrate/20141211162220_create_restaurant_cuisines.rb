class CreateRestaurantCuisines < ActiveRecord::Migration
  def change
    create_table :restaurant_cuisines do |t|
      t.integer :restaurant_id
      t.integer :cuisine_id
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :restaurant_cuisines, :restaurant_id
    add_index :restaurant_cuisines, :cuisine_id
    add_index :restaurant_cuisines, :archived
  end
end
