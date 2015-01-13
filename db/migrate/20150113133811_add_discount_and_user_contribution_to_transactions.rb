class AddDiscountAndUserContributionToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :discount, :float, default: 0, null: false
    add_column :transactions, :user_contribution, :float, default: 0, null: false
  end
end
