class AddInfoToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :facture_number, :string
    add_column :invoices, :commission_percentage, :float
    add_column :invoices, :pre_tax_owed, :float
    add_column :invoices, :total_owed, :float
    add_column :invoices, :final_balance, :float
  end
end
