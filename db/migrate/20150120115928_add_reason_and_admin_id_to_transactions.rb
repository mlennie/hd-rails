class AddReasonAndAdminIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :reason, :string
    add_column :transactions, :admin_id, :integer
    add_index :transactions, :admin_id
  end
end
