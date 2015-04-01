class CreateRestaurantServiceTemplates < ActiveRecord::Migration
  def change
    create_table :restaurant_service_templates do |t|
      t.integer :service_template_id
      t.integer :restaurant_id
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :restaurant_service_templates, :service_template_id
    add_index :restaurant_service_templates, :restaurant_id
    add_index :restaurant_service_templates, :archived
  end
end
