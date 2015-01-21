class AddReferralAmountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :referral_amount, :integer
  end
end
