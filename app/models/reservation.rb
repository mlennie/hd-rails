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

  after_save :update_current_discount_to_service
  before_create :add_confirmation
  after_create :send_new_reservation_emails
  after_create :send_delayed_validation_email

  just_define_datetime_picker :time

  validates_presence_of :nb_people, :time, :restaurant_id, :user_id, 
                        :discount, :user_contribution, :booking_name
                        #:service_id

  def add_confirmation
    confirmation = generate_confirmation
    self.confirmation = confirmation
  end

  def earnings
    t = self.transactions.first
    return nil unless (t.try(:final_balance) && t.try(:original_balance))
    amount = t.final_balance - t.original_balance
    return amount.round(2).to_s.gsub(/\./, ',')
  end

  def create_transactions_and_update_reservation params
    amount_param = params[:reservation][:bill_amount].to_f
    discount_param = params[:reservation][:discount].to_f
    user_contribution_param = params[:reservation][:user_contribution].to_f
    #add transaction so that both transaction updates need to be successful
    #or else everything does a rollback
    ActiveRecord::Base.transaction do 
      #make transaction for user
      t1 = Transaction.create_reservation_transaction(
        amount_param, discount_param, user_contribution_param, self, user
      )
      #make transaction for restaurant
      t2 = Transaction.create_reservation_transaction(
        amount_param, discount_param, user_contribution_param, self, restaurant
      )
      RelatedTransaction.create(
        transaction_id: t1.id,
        other_transaction_id: t2.id
      )
      #update reseration
      self.update(status: 'validated')

      #send money to referrer if this is user's first reservation
      #and if user was referred by another user
      user.send_money_to_referrer 

      #send email to user telling them they recieved money for their reservation
      user.send_received_reservation_money_email t1, self
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
    #make sure bill amount, discount and user contribution are present
    params[:reservation][:bill_amount].present? &&
    params[:reservation][:discount].present? &&
    params[:reservation][:user_contribution].present? &&
    #add transactions only if bill amount has changed and no 
    # transactions exist already and either discount or user_contribution 
    #is more than 0
    transactions.get_unarchived.empty? && 

    #get params
    (amount_param = params[:reservation][:bill_amount].to_f) &&
    (discount_param = params[:reservation][:discount].to_f) &&
    (user_contribution_param = params[:reservation][:user_contribution].to_f) &&
    
    amount_param.present? && 
    (discount_param > 0 || user_contribution_param > 0)
  end

  def transactions_should_be_reset? params
    #make sure transactions exist
    transactions.get_unarchived.any? && 

    #make sure bill amount, discount and user contribution are present
    params[:reservation][:bill_amount].present? &&
    params[:reservation][:discount].present? &&
    params[:reservation][:user_contribution].present? &&
    #get params
    (amount_param = params[:reservation][:bill_amount].to_f) &&
    (discount_param = params[:reservation][:discount].to_f) &&
    (user_contribution_param = params[:reservation][:user_contribution].to_f) &&

    #make sure bill amount is set
    amount_param.present? &&

    #make sure either discount or user_contribution is set
    (discount_param > 0 || user_contribution_param > 0) &&

    #check if reservation has any unarchived transactions
    transactions.get_unarchived.any? &&
    
    #check to see if bill amounts differ 
    (amount_param != bill_amount ||

    #check to see if discounts differ
    discount_param != discount ||

    #check to see if user_contributions differ
    user_contribution_param != user_contribution)
  end

  def send_new_reservation_emails
    #only send emails if reservation is for the future
    if self.time > Time.now - 10.minutes
      #send new reservation email to user
      UserMailer.new_reservation(self).deliver 
      #send new reservation email to restaurant
      RestaurantMailer.new_reservation(self).deliver 
      #send new reservation email to admin
      AdminMailer.new_reservation(self).deliver
    end
  end

  #change current discount for service when new reservation is made
  #or when one is cancelled
  def update_current_discount_to_service
    service = self.service
    #get spots already taken
    availabilities = service.availabilities
    spots_taken = service.reservations.get_unarchived.where(
                    "status != ?", Reservation.statuses[:cancelled]
                  ).count

    #get percentage availabilites
    number_of_ten_available = service.nb_10
    number_of_fifteen_available = service.nb_15
    number_of_twenty_available = service.nb_20
    number_of_twenty_five_available = service.nb_25

    #get new current discount
    #return 0 if no spots left
    if spots_taken >= availabilities 
      discount = 0
    #start highest to lowest percentages 
    #to see which percentage is still available 
    elsif spots_taken < number_of_twenty_five_available
      discount = 0.25
    elsif spots_taken < number_of_twenty_available
      discount = 0.20
    elsif spots_taken < number_of_fifteen_available
      disccount = 0.15
    else
      discount = 0.10
    end
    service.update(current_discount: discount)
  end

  #send email to restaurant 1 hour 45 minutes after reservation starts
  def send_delayed_validation_email
    #paris time is one hour past UTC time(which rails uses)
    paris_time = self.time - 1.hour
    #get delayed time
    delayed_time = paris_time + 1.hour + 45.minutes
    #get info for emails
    booking_name = self.booking_name
    email = self.restaurant.principle_email
    restaurant_name = self.restaurant.name
    #send delayed emails
    if delayed_time > Time.now
      ReservationValidationEmailWorker.perform_at(delayed_time, booking_name, email, restaurant_name )
    end
  end

  private

  def generate_confirmation
    loop do
      token = SecureRandom.hex[0,8]
      break token unless Reservation.where(confirmation: token).first
    end
  end
end
