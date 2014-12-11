class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :confirmation
      t.integer :nb_people
      t.datetime :time
      t.integer :status
      t.datetime :viewed_at
      t.datetime :cancelled_at
      t.datetime :validated_at
      t.datetime :absent_at
      t.datetime :finalized_at
      t.integer :restaurant_id
      t.integer :user_id
      t.integer :service_id
      t.float :bill_amount
      t.float :user_balance
      t.float :restaurant_balance
      t.integer :discount
      t.float :user_contribution
      t.string :booking_name
      t.boolean :archived

      t.timestamps
    end
    add_index :reservations, :restaurant_id
    add_index :reservations, :user_id
    add_index :reservations, :service_id
  end
end
