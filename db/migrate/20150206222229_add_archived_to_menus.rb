class AddArchivedToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :archived, :boolean
    add_index :menus, :archived
  end
end
