class Wallet < ActiveRecord::Base
	include Archiving
	
  has_many :transactions
  belongs_to :concernable, polymorphic: true

  def self.create_for_user user
  	user.create_wallet unless user.wallet.present?
  end
end
