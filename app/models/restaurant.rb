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
  has_many :restaurant_cuisines
  has_many :cuisines, through: :restaurant_cuisines
  has_many :menus

  #add geolocation and reverse geolocation
  geocoded_by :full_street_address
  after_validation :geocode, if: :full_street_address_changed?
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.geocoded_address = geo.address 
    end
  end
  after_validation :reverse_geocode, if: :full_street_address_changed?

  after_save :create_new_wallet

  validates_presence_of :name, :principle_email

  def to_s
    unless name.blank? 
      name
    else
      email
    end
  end

  def full_street_address
    street + city + country + zipcode
  end

  def full_street_address_changed?
    if street == nil ||
      city == nil ||
      country == nil ||
      zipcode == nil
      return false
    else
      street_changed? || city_changed? || country_changed? || zipcode_changed?
    end
  end

  def create_new_wallet
    Wallet.create_for_concernable self
  end

  def full_address
    street + ', ' + city + ', ' + zipcode
  end
end
