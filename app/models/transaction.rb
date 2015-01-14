class Transaction < ActiveRecord::Base
  include Archiving
  
  belongs_to :concernable, polymorphic: true
  belongs_to :itemable, polymorphic: true
  belongs_to :wallet
  has_many :related_transactions

  enum kind: [ :reservation, :payment, :withdrawal, :referral, :promotion, 
               :adjustment ]

  def self.create_transaction(amount, discount, user_contribution, 
                              reservation, concernable)
  	#build new transaction 
    transaction = Transaction.new

    #add concernable to transaction
    transaction.concernable = concernable

    #add reservation to transaction
    transaction.itemable = reservation

    #set transaction kind
    transaction.kind = "reservation"

    #set transaction discount and user contribution
    transaction.discount = discount
    transaction.user_contribution = user_contribution

    #add wallet if concernable doesn't have one already
    concernable.create_new_wallet unless concernable.wallet.present?
    #make balance 0 incase its nil
    concernable.wallet.update(balance: 0) if concernable.wallet.balance.blank?
    #set transaction original balance
    original_balance = transaction.original_balance = concernable.wallet.balance

    #set transaction amount
    transaction.amount = amount
    #set whether transaction is positive or not and update final balance
    if discount > 0 # if discount used
      transaction.amount_positive = (concernable.class.name == 'User') ? true : false
      if concernable.class.name == 'User'
      	transaction.final_balance = original_balance + amount * discount
      else
      	transaction.final_balance = original_balance - amount * discount
      end
    else # if user used their euros
      transaction.amount_positive = (concernable.class.name == 'User') ? false : true
      if concernable.class.name == 'User'
      	transaction.final_balance = original_balance - user_contribution
      else
      	transaction.final_balance = original_balance + user_contribution
      end
    end

    #update user wallet balance
    concernable.wallet.update(balance: transaction.final_balance)

    #save transaction
    transaction.save!
  end
end
