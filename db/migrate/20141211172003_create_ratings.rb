class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :restaurant_id
      t.integer :reservation_id
      t.integer :number
      t.text :comment
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :ratings, :user_id
    add_index :ratings, :restaurant_id
    add_index :ratings, :reservation_id
    add_index :ratings, :archived
  end
end
