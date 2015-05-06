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

  def billing_address
    return {
      company: billing_company,
      street: billing_street,
      city: billing_city,
      zipcode: billing_zipcode,
      country: billing_country
    }
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

  #get date params for second step of invoice creation
  def self.get_date_params params
    start_date = params[:invoice][:start_date]
    end_date = params[:invoice][:end_date]
    return { start_date: start_date, end_date: end_date }
  end

  #get invoice end date array for when creating invoices
  def get_invoice_end_date_array
    if self.created_at > Time.new - 1.month
      return ["Restaurant is less than one month old. Cannot create invoice"]
    else
      date_array = []
      start_date = self.get_invoice_start_date
      #get date of last day of last month
      last_month_end_date = Time.new.prev_month.end_of_month #eg: 2015-03-31 23:59:59 +0200
      #loop through months adding each one to array and then going back 
      #another month until reaching starting month
      current_date = last_month_end_date
      while current_date >= start_date
        date_array << current_date.end_of_month.to_date
        current_date -= 1.month 
        current_date = current_date.end_of_month
      end
      return date_array
    end
  end

  #calculate information for invoice
  def self.calculate_information_for_invoice params

    #get restaurant
    restaurant = Restaurant.find(params[:restaurant_id])

    #create invoice object
    invoice = {} 
    invoice[:start_date] = params[:start_date].to_date
    invoice[:end_date] = params[:end_date].to_date
    invoice[:business_address] = restaurant.billing_address
    invoice[:client_number] = "A000" + restaurant.id.to_s
    invoice[:facture_number] = "A" + restaurant.id.to_s + '-' + (restaurant.invoices.get_unarchived.count + 1).to_s
    invoice[:pre_tax_owed] = 100 #sum of all reservation bill amounts * percentage for this restaurant + tax
    invoice[:total_owed] =  invoice[:pre_tax_owed] * 1.2 #pre_tax_owed times 20%
    percentage = 
    invoice[:formatted_percentage]
    return invoice
  end

  def full_address
    street + ', ' + city + ', ' + zipcode
  end
end








