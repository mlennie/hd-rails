class CreateServiceTemplates < ActiveRecord::Migration
  def change
    create_table :service_templates do |t|
      t.string :name
      t.string :description
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :service_templates, :archived
  end
end
