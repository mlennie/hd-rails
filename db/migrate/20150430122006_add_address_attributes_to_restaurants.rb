class AddAddressAttributesToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :billing_company, :string
    add_column :restaurants, :billing_street, :string
    add_column :restaurants, :billing_zipcode, :string
    add_column :restaurants, :billing_city, :string
    add_column :restaurants, :billing_country, :string
  end
end
