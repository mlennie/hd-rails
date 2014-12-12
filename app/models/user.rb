class User < ActiveRecord::Base

  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :validatable, :confirmable, :lockable

  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :restaurants
  has_many :reservations
  has_many :ratings
  has_many :favorite_restaurants
  has_many :wallets
  has_many :transactions
  has_many :reservation_errors
  has_many :user_promotions
  has_many :promotions, through: :user_promotions


  def is_superadmin?
    roles.include? Role.superadmin
  end

  def self.get_unarchived
    User.where(archived: false)
  end

  def archive
    self.update(archived: true)
  end
end
