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

  def create_new_wallet
    Wallet.create_for_concernable self
  end
end
