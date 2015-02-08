class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :name
      t.string :title
      t.string :description
      t.integer :kind
      t.float :price
      t.integer :restaurant_id
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :menus, :restaurant_id
  end
end
