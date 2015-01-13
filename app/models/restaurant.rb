class Restaurant < ActiveRecord::Base
  include Archiving

  has_many :services
  has_many :reservations
  has_many :reservation_errors
  has_many :ratings
  belongs_to :user
  has_many :favorite_restaurants
  has_many :favorite_users, through: :favorite_restaurants, source: :users
  has_one :wallet, as: :concernable
  has_many :transactions, as: :concernable
  has_many :invoices

  after_save :create_new_wallet

  def to_s
    unless name.blank? 
      name
    else
      email
    end
  end

  def create_reservation_transaction amount discount user_contribution reservation
    #build new transaction and add restaurant to it
    transaction = self.transactions.build

    #add reservation to transaction
    transaction.itemable = reservation

    #set transaction kind
    transaction.kind = "reservation"

    #add wallet if restaurant doesn't have one already
    unless wallet.present?
      Wallet.create_for_concernable self
    end
    #make balance 0 incase its nil
    if wallet.balance.blank?
      wallet.update(balance: 0) 
    end
    #set transaction original balance
    original_balance = transaction.original_balance = wallet.balance

    #set transaction amount
    transaction.amount = amount

    #set whether transaction is positive or not and update final balance
    if discount > 0 # if discount used
      transaction.amount_positive = false
      transaction.final_balance = original_balance - amount * discount
    else # if user used their euros
      transaction.amount_positive = true
      transaction.final_balance = original_balance + user_contribution
    end

    #update restaurant wallet balance
    wallet.update(balance: final_balance)
  end

  def create_new_wallet
    Wallet.create_for_concernable self
  end
end
