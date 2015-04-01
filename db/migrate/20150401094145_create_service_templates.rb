class CreateServiceTemplates < ActiveRecord::Migration
  def change
    create_table :service_templates do |t|
      t.string :name
      t.string :description
      t.integer :restaurant_id
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :service_templates, :archived
    add_index :service_templates, :restaurant_id
  end
end
