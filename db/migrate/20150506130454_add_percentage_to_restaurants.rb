class AddPercentageToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :commission_percentage, :float
  end
end
