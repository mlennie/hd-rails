class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.string :description
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :roles, :archived
  end
end
