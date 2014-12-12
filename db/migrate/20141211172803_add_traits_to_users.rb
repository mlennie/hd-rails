class AddTraitsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_name, :string
    add_column :users, :first_name, :string
    add_column :users, :referrer_id, :integer
    add_index :users, :referrer_id
    add_column :users, :referrer_paid, :boolean
    add_column :users, :phone, :string
    add_column :users, :birth_date, :date
    add_column :users, :gender, :string
    add_index :users, :gender
    add_column :users, :wallet_id, :integer
    add_index :users, :wallet_id
    add_column :users, :street, :string
    add_column :users, :district, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :country, :string
    add_column :users, :zipcode, :string
    add_column :users, :geocoded_address, :string
    add_column :users, :lat, :integer
    add_column :users, :lng, :integer
    add_column :users, :archived, :boolean, default: false
    add_index :users, :archived
  end
end
