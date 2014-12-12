class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :name
      t.string :code
      t.text :description
      t.float :amount
      t.integer :percent
      t.boolean :new_user_only
      t.datetime :expiry_date
      t.integer :usage_limit
      t.integer :times_used
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :promotions, :archived
  end
end
