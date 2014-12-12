class CreateRelatedTransactions < ActiveRecord::Migration
  def change
    create_table :related_transactions do |t|
      t.integer :transaction_id
      t.integer :other_transaction_id
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :related_transactions, :transaction_id
    add_index :related_transactions, :other_transaction_id
    add_index :related_transactions, :archived
  end
end
