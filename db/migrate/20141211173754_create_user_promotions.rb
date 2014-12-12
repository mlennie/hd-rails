class CreateUserPromotions < ActiveRecord::Migration
  def change
    create_table :user_promotions do |t|
      t.integer :user_id
      t.integer :reservation_id
      t.integer :promotion_id
      t.integer :usage_case
      t.boolean :archived, default: false

      t.timestamps
    end
    add_index :user_promotions, :user_id
    add_index :user_promotions, :reservation_id
    add_index :user_promotions, :promotion_id
    add_index :user_promotions, :archived
  end
end
