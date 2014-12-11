class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.float :previous_balance
      t.float :additional_balance
      t.integer :hd_percent
      t.datetime :due_date
      t.datetime :date_paid
      t.string :confirmation
      t.float :total_amount_paid
      t.integer :restaurant_id
      t.boolean :archived

      t.timestamps
    end
    add_index :invoices, :restaurant_id
  end
end
