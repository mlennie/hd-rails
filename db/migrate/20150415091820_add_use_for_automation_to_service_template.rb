class AddUseForAutomationToServiceTemplate < ActiveRecord::Migration
  def change
    add_column :service_templates, :use_for_automation, :boolean, default: false
    add_index :service_templates, :use_for_automation
  end
end
