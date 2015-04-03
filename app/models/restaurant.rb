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
  has_many :service_templates

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

  def self.use_template_to_create_services params
    date = params[:date]
    service_template = ServiceTemplate.find(params[:service_template_id].to_i)
    restaurant = Restaurant.find(params[:restaurant_id].to_i)
    week_one = params[:week_one]
    week_two = params[:week_two]
    week_three = params[:week_three]
    week_four = params[:week_four]
    week_five = params[:week_five]
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
