class AddCurrentDiscountToServices < ActiveRecord::Migration
  def change
    add_column :services, :current_discount, :float
  end
end
