class CreateCuisines < ActiveRecord::Migration
  def change
    create_table :cuisines do |t|
      t.string :name
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :cuisines, :archived
  end
end
