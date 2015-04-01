class AddServiceTemplateIdToServices < ActiveRecord::Migration
  def change
    add_column :services, :service_template_id, :integer
    add_index :services, :service_template_id
  end
end
