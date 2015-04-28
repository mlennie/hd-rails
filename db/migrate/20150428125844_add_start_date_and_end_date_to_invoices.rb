class AddStartDateAndEndDateToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :start_date, :datetime
    add_column :invoices, :end_date, :datetime
  end
end
