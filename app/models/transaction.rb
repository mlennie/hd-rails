class Transaction < ActiveRecord::Base
  belongs_to :concernable, polymorphic: true
  belongs_to :itemable, polymorphic: true
  belongs_to :wallet
  has_many :related_transactions
  has_many :linked_transactions, through: :related_transactions,
           source: :transactions, foreign_key: :other_transaction_id

  enum kind: [ :reservation, :payment, :withdrawal, :referral, :promotion ]
end
