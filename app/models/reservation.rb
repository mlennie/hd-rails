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

  def create_transactions amount
    #add transaction so that both transaction updates need to be successful
    #or else everything does a rollback
    ActiveRecord::Base.transaction do 
      #make transaction for user
      puts "amount:" + amount.to_s
      Transaction.create_transaction(
        amount, discount, user_contribution, self, user
      )
      #make transaction for restaurant
      Transaction.create_transaction(
        amount, discount, user_contribution, self, restaurant
      )
      self.update(status: 'validated')
      self.update(bill_amount: amount)
    end
  end

  def transactions_should_be_created? amount_param, discount_param, user_contribution_param
    #add transactions only if bill amount has changed and no 
    # transactions exist already and either discount or user_contribution 
    #is more than 0
    transactions.get_unarchived.empty? && 
    amount_param.present? && 
    discount > 0 || user_contribution > 0
  end

  def transactions_should_be_reset? amount_param, discount_param, user_contribution_param

    #make sure bill amount is set
    amount_param.present? &&

    discount > 0 || user_contribution > 0

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
