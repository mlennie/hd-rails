class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.float :balance
      t.string :concernable_type
      t.integer :concernable_id
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :wallets, :concernable_id
    add_index :wallets, :archived
  end
end
