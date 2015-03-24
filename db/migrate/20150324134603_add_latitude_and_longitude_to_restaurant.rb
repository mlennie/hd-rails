class AddLatitudeAndLongitudeToRestaurant < ActiveRecord::Migration
  def up
    add_column :restaurants, :latitude, :float
    add_column :restaurants, :longitude, :float
    remove_column :restaurants, :lat
  	remove_column :restaurants, :lng
  end

  def down
  	remove_column :restaurants, :latitude
  	remove_column :restaurants, :longitude
  	add_column :restaurants, :lat, :integer
    add_column :restaurants, :lng, :integer
  end
end
