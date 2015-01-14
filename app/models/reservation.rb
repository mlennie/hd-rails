class Reservation < ActiveRecord::Base

  include Archiving

  enum status: [ :not_viewed, :viewed, :cancelled, :validated, :finished ]

  belongs_to :user
  belongs_to :restaurant
  belongs_to :service
  has_one :rating
  has_many :reservation_errors
  has_many :user_promotions
  has_many :promotions, through: :user_promotions
  has_many :transactions, as: :itemable

  before_save :add_confirmation

  just_define_datetime_picker :time

  validates_presence_of :nb_people, :time, :restaurant_id, :user_id, 
                        :discount, :user_contribution, :booking_name

  def add_confirmation
    confirmation = generate_confirmation
    self.confirmation = confirmation
  end

  def create_transactions_and_update_reservation params
    amount_param = params[:reservation][:bill_amount].to_f
    discount_param = params[:reservation][:discount].to_f
    user_contribution_param = params[:reservation][:user_contribution].to_f
    #add transaction so that both transaction updates need to be successful
    #or else everything does a rollback
    ActiveRecord::Base.transaction do 
      #make transaction for user
      Transaction.create_transaction(
        amount_param, discount_param, user_contribution_param, self, user
      )
      #make transaction for restaurant
      Transaction.create_transaction(
        amount_param, discount_param, user_contribution_param, self, restaurant
      )

      #update reseration
      self.update(status: 'validated')
    end
  end

  def update_transactions_and_wallets params
    ActiveRecord::Base.transaction do 
      archive_transactions_and_reset_wallet
      create_transactions_and_update_reservation params
    end
  end

  #when updating a reservation bill amount, discount or user contribution
  #after a reservations' transactions have already been made
  #call this before creating new transactions to reset changes from 
  #already created reservation transactions
  def archive_transactions_and_reset_wallet
    #add transaction so that both transaction updates need to be successful
    #or else everything does a rollback
    ActiveRecord::Base.transaction do
      #loop through all transactions that belong to this reservation 
      #that are not archived
      transactions.get_unarchived.each do |transaction|
        #get diff in balance change
        diff = transaction.final_balance - transaction.original_balance

        #get concernable (user or restaurant) information
        concernable = transaction.concernable
        wallet = concernable.wallet
        balance = wallet.balance 

        #reset concernable balance 
        new_balance = wallet.balance - diff
        wallet.update(balance: new_balance)

        #archive transaction
        transaction.update(archived: true)
      end
    end
  end

  def transactions_should_be_created? params
    #get params
    (amount_param = params[:reservation][:bill_amount].to_f) &&
    (discount_param = params[:reservation][:discount].to_f) &&
    (user_contribution_param = params[:reservation][:user_contribution].to_f) &&
    
    #add transactions only if bill amount has changed and no 
    # transactions exist already and either discount or user_contribution 
    #is more than 0
    transactions.get_unarchived.empty? && 
    amount_param.present? && 
    discount_param > 0 || user_contribution_param > 0
  end

  def transactions_should_be_reset? params
    #get params
    (amount_param = params[:reservation][:bill_amount].to_f) &&
    (discount_param = params[:reservation][:discount].to_f) &&
    (user_contribution_param = params[:reservation][:user_contribution].to_f) &&

    #make sure bill amount is set
    amount_param.present? &&

    #make sure either discount or user_contribution is set
    discount_param > 0 || user_contribution_param > 0 &&

    #check if reservation has any unarchived transactions
    transactions.get_unarchived.any? &&
    
    #check to see if bill amounts differ 
    amount_param != bill_amount ||

    #check to see if discounts differ
    discount_param != discount ||

    #check to see if user_contributions differ
    user_contribution_param != user_contribution
  end

  private

  def generate_confirmation
    loop do
      token = SecureRandom.hex[0,8]
      break token unless Reservation.where(confirmation: token).first
    end
  end
end
