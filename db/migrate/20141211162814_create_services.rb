class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.integer :availabilities
      t.datetime :start_time
      t.datetime :last_booking_time
      t.integer :restaurant_id
      t.integer :nb_10
      t.integer :nb_15
      t.integer :nb_20
      t.integer :nb_25
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :services, :restaurant_id
    add_index :services, :archived
  end
end
