class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :phone
      t.string :street
      t.string :district
      t.string :city
      t.string :country
      t.string :zipcode
      t.string :geocoded_address
      t.integer :lat
      t.integer :lng
      t.integer :user_id
      t.boolean :archived, default: false
      t.integer :wallet_id

      t.timestamps
    end
    add_index :restaurants, :user_id
    add_index :restaurants, :wallet_id
    add_index :restaurants, :archived
  end
end
