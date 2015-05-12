class AddPhoneToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :phone, :string
  end
end
