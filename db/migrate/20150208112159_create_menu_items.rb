class CreateMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.integer :course
      t.string :name
      t.string :description
      t.float :price
      t.integer :menu_id
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :menu_items, :menu_id
  end
end
