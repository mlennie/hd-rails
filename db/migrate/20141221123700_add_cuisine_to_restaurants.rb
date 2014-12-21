class AddCuisineToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :cuisine, :integer
  end
end
