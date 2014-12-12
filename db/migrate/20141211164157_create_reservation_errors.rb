class CreateReservationErrors < ActiveRecord::Migration
  def change
    create_table :reservation_errors do |t|
      t.integer :reservation_id
      t.integer :user_id
      t.integer :kind
      t.text :description
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :reservation_errors, :reservation_id
    add_index :reservation_errors, :user_id
    add_index :reservation_errors, :archived
  end
end
