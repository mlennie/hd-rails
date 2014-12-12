class Wallet < ActiveRecord::Base
  has_many :transactions
  belongs_to :concernable, polymorphic: true
end
