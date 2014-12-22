class AddDescriptionAndImgToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :description, :text
    add_column :restaurants, :img_url, :string
  end
end
