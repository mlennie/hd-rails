class AddRestaurantIdToReservationsErrors < ActiveRecord::Migration
  def change
    add_column :reservation_errors, :restaurant_id, :integer
    add_index :reservation_errors, :restaurant_id
  end
end
