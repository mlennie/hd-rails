class Wallet < ActiveRecord::Base
	include Archiving
	
  has_many :transactions
  belongs_to :concernable, polymorphic: true

  def self.create_for_concernable concernable
  	concernable.create_wallet unless concernable.wallet.present?
  end
end
