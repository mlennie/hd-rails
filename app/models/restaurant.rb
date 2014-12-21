class Restaurant < ActiveRecord::Base
  include Archiving

  enum cuisine: [ :italian, :french, :spanish, :world ]

  has_many :services
  has_many :reservations
  has_many :reservation_errors
  has_many :ratings
  belongs_to :user
  has_many :favorite_restaurants
  has_many :favorite_users, through: :favorite_restaurants, source: :users
  has_many :wallets
  has_many :transactions
  has_many :invoices
end
