class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.integer :course
      t.string :description
      t.float :price
      t.integer :restaurant_id

      t.timestamps
    end
    add_index :menus, :course
    add_index :menus, :restaurant_id
  end
end
