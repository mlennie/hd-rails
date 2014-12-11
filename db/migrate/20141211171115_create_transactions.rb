class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :kind
      t.float :original_balance
      t.float :amount
      t.boolean :amount_positive
      t.float :final_balance
      t.string :confirmation
      t.string :itemable_type
      t.integer :itemable_id
      t.string :concernable_type
      t.integer :concernable_id
      t.boolean :archived

      t.timestamps
    end
    add_index :transactions, :itemable_id
    add_index :transactions, :concernable_id
  end
end
