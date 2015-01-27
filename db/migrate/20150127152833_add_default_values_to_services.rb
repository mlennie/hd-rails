class AddDefaultValuesToServices < ActiveRecord::Migration
  def up
	  change_column :services, :nb_10, :integer, :default => 0
	  change_column :services, :nb_15, :integer, :default => 0
	  change_column :services, :nb_20, :integer, :default => 0
	  change_column :services, :nb_25, :integer, :default => 0
	  change_column :services, :current_discount, :float, :default => 0
	end

	def down
	  change_column :services, :nb_10, :integer, :default => nil
	  change_column :services, :nb_15, :integer, :default => nil
	  change_column :services, :nb_20, :integer, :default => nil
	  change_column :services, :nb_25, :integer, :default => nil
	  change_column :services, :current_discount, :float, :default => nil
	end
end
