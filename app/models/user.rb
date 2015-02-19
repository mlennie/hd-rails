class User < ActiveRecord::Base
  include Archiving

  before_save :ensure_authentication_token
  before_save :ensure_referral_code

  after_create :create_new_wallet
  after_create :send_congrats_email_to_referrer

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

  def self.check_wallet_and_include_associations params
    #create wallet for user if user doesn't have one already
    #and then find use and include wallet, roles and restaurants
    user = find(params[:id])
    Wallet.create_for_user user unless user.wallet.present?
    includes(:wallet, :roles, :restaurants).find(params[:id])
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

  def create_new_wallet
    Wallet.create_for_concernable self
  end

  def save_user_and_apply_extras promotion, referred_user_code
    #check if referral code is present and apply if so
    if referred_user_code.present?
      #find referrer
      referrer = User.find_by(referral_code: referred_user_code)
      #set user's referral id to referrers id if referrer present
      if referrer.present?
        self.referrer_id = referrer.id 
        self.referral_amount = 5
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
