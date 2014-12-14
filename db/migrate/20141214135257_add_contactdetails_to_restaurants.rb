class AddContactdetailsToRestaurants < ActiveRecord::Migration
  def change
    remove_column :restaurants, :phone
    add_column :restaurants, :owner_name, :string
    add_column :restaurants, :responsable_name, :string
    add_column :restaurants, :communications_name, :string
    add_column :restaurants, :server_one_name, :string
    add_column :restaurants, :server_two_name, :string
    add_column :restaurants, :restaurant_phone, :string
    add_column :restaurants, :responsable_phone, :string
    add_column :restaurants, :principle_email, :string
    add_column :restaurants, :second_email, :string
    add_column :restaurants, :other_restaurants, :string
  end
end
