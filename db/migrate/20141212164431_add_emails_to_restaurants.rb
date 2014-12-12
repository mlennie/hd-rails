class AddEmailsToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :emails, :string
  end
end
