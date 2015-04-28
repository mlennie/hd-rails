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
  has_many :menus

  after_save :create_new_wallet

  validates_presence_of :name, :principle_email

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

  #get invoice start date for when creating invoices
  def get_invoice_start_date
    #check if has invoices already or not
    if self.invoices.get_unarchived.any?

    else
      #if doesn't have invoices yet, get created at date
      return self.created_at
    end
  end

  def full_address
    street + ', ' + city + ', ' + zipcode
  end
end
