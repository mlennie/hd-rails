class User < ActiveRecord::Base
  include Archiving

  before_save :ensure_authentication_token
  after_save :create_new_wallet

  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :validatable, :confirmable, :lockable

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


  def is_superadmin?
    roles.include? Role.superadmin
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
    self.update(reset_password_token: token)
    self.update(reset_password_sent_at: Time.now)
  end 

  def create_new_wallet
    Wallet.create_for_concernable self
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
end
