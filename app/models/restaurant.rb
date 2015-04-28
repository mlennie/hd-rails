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
    #make sure restaurant is more than one month old
    if self.created_at > Time.new - 1.month
      return "Restaurant is less than one month old. Cannot create invoice"
    else  
      #check if has invoices already or not
      if self.invoices.get_unarchived.any?

      else
        #if doesn't have invoices yet, get created at date
        return self.created_at.to_date
      end
    end
  end

  #get invoice end date array for when creating invoices
  def get_invoice_end_date_array
    if self.created_at > Time.new - 1.month
      return ["Restaurant is less than one month old. Cannot create invoice"]
    elsif 
      date_array = []
      start_date = self.get_invoice_start_date
      #get date of last day of last month
      last_month_end_date = Time.new.prev_month.end_of_month #eg: 2015-03-31 23:59:59 +0200
      #loop through months adding each one to array and then going back 
      #another month until reaching starting month
      current_date = last_month_end_date
      while current_date.month >= start_date.month
        date_array << current_date.end_of_month
        current_date = current_date - 1.month
      end
      return date_array
    end
  end

  def full_address
    street + ', ' + city + ', ' + zipcode
  end
end
