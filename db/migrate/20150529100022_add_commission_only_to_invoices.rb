class AddCommissionOnlyToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :commission_only, :boolean
  end
end
