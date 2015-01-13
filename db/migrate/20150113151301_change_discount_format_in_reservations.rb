class ChangeDiscountFormatInReservations < ActiveRecord::Migration
  def up
    change_column :reservations, :discount, :float
  end

  def down
    change_column :reservations, :discount, :integer
  end
end
