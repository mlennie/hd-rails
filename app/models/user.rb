class User < ActiveRecord::Base
  include Archiving

  before_save :ensure_authentication_token
  before_save :ensure_referral_code

  before_create :create_new_wallet
  after_create :give_user_money_if_referred
  after_create :send_congrats_email_to_referrer
  after_create :create_new_preferences

  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :validatable, :confirmable, :lockable

  validates_presence_of :last_name, :first_name, :email, :gender
  validates_inclusion_of :gender, in: ["Male", "Female"]

  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :restaurants
  has_many :reservations
  has_many :ratings
  has_many :favorite_restaurants
  has_one :wallet, as: :concernable
  has_many :transactions, as: :concernable
  has_many :reservation_errors
  has_many :user_promotions
  has_many :promotions, through: :user_promotions
  has_one :referral_transaction, as: :itemable
  has_one :preferences


  def is_superadmin?
    roles.include? Role.superadmin
  end

  def full_name
    unless first_name.blank? || last_name.blank?
      first_name + " " + last_name
    else
      email
    end
  end

  #use heroku schedular to send confirmation reminder
  #emails to users that have not confirmed their account 
  #for more than a day
  def self.send_confirmation_reminder_emails
    #since heroku's only option is either every ten minutes, hour or day
    #we first check to see if it's a the day we want. 
    #If its not, leave method
    return if !Time.new.friday?

    #find all unarchived users who have not confirmed for more than a day
    User.get_unarchived
        .where(confirmed_at: nil)
        .where('created_at < ?', Time.new.midnight)        
        .find_each do |user|
          #create preferences table for user if user doesn't have one yet
          user.create_new_preferences 
          #don't send to users that have unsubscribed from emailing.
          unless user.preferences.receive_emails === false
            UserMailer.confirmation_reminder(user).deliver
          end
        end 
  end

  def self.check_wallet_and_include_associations params
    #create wallet for user if user doesn't have one already
    #and then find use and include wallet, roles and restaurants
    user = find(params[:id])
    Wallet.create_for_user user unless user.wallet.present?
    includes(:wallet, :roles, :restaurants, :reservations).find(params[:id])
  end

  def self.exists_and_has_names? params
    params[:user_id].present? &&
    find(params[:user_id]).first_name.present? &&
    find(params[:user_id]).last_name.present?
  end

  def to_s
    unless self.last_name.blank? || self.first_name.blank?
      last_name + ' ' + first_name + ': ' + email
    else
      email
    end
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def update_reset_password_token
    token = generate_reset_password_token
    self.reset_password_token = token
    self.reset_password_sent_at = Time.now
    self.save(validate: false)
  end 

  #create and associate a wallet to newly created user 
  def create_new_wallet
    Wallet.create_for_concernable self
  end

  #create and associate a preferences table for newly created user
  def create_new_preferences
    Preferences.create_for_user self
  end

  #after user is created give them money if they were referred by another user
  def give_user_money_if_referred
    if self.referrer_id.present?
      Transaction.create_referral_transaction self.referral_amount, self, User.find(self.referrer_id)
    end
  end

  def save_user_and_apply_extras promotion, referred_user_code
    #check if referral code is present and apply if so
    if referred_user_code.present?
      #find referrer
      referrer = User.find_by(referral_code: referred_user_code)
      #set user's referral id to referrers id if referrer present
      if referrer.present?
        self.referrer_id = referrer.id 
        self.referral_amount = ENV["REFERRAL_AMOUNT"]
      end
    end

    #check if promotion is present and apply if so
    if promotion.blank?
      self.save
    else
      ActiveRecord::Base.transaction do 
        self.save
        promotion.apply_to self
      end
    end
  end

  def ensure_referral_code
    if referral_code.blank?
      self.referral_code = generate_referral_code
    end
  end

  def send_congrats_email_to_referrer
    unless self.referrer_id.blank?
      UserMailer.new_referral_registration(self).deliver 
    end
  end

  def send_money_to_referrer
    #make sure user was referred and referrer hasn't been paid yet
    #and user only has one validated reservation
    if self.referrer_id.present? && self.referrer_paid.blank? &&
      self.reservations.validated.count === 1
      ActiveRecord::Base.transaction do 
        #update users referrer paid attribute to show referrer has been paid
        self.update(referrer_paid: true)

        #get amount
        amount = self.referral_amount

        #get referrer
        referrer = User.find(self.referrer_id)

        #create transaction to pay user
        Transaction.create_referral_transaction amount, referrer, self
      end

      #send payment email
      UserMailer.new_referral_payment(self).deliver 
    else
      return true
    end
  end

  #send email to user after they finished a reservation telling them they 
  #received money
  def send_received_reservation_money_email transaction, reservation

    #make sure transaction is positive and users last transaction is the new 
    #transaction that was just created
    if transaction.amount_positive &&
      self.transactions.last === transaction 
      amount = transaction.final_balance - transaction.original_balance
      amount = amount.round(2).to_s.gsub(/\./, ',')
      UserMailer.received_reservation_money(self, amount, reservation).deliver
    end

    return true
  end

  private

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end

    def generate_reset_password_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(reset_password_token: token).first
      end
    end

    def generate_referral_code
      loop do
        token = SecureRandom.hex[0,15]
        break token unless User.where(referral_code: token).first
      end
    end
end
