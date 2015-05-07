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
      #get older invoices
      past_invoices = self.invoices.get_unarchived
      #check if has past paid invoices
      if past_invoices.where(paid: true).any?
        #check if last invoice was paid
        if past_invoices.last.paid?
          #start invoice from start of month after paid invoice
          start_date = (past_invoices.last.end_date.at_beginning_of_month + 1.month).to_date
        else 
          #not paid so start invoice from start of month after previously 
          #paid invoice (start building invoices as if last invoice, which 
          #wasn't paid, did not exist) (last unpaid invoice will be archived 
          #if this new invoice is created )
          last_paid_invoice = past_invoices.where(paid: true).last
          start_date = (last_paid_invoice.end_date.at_beginning_of_month + 1.month).to_date
        end
        #make sure there is at least a full month for the invoice
          if start_date >= Time.new.at_beginning_of_month.to_date 
            return "It has not been at least one month since the last paid invoice was sent"
          else
            return start_date
          end
      else
        #if doesn't have any paid invoices yet, get created at date
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

  #archive all unpaid invoices
  def archive_unpaid_invoices new_invoice
    self.invoices.get_unarchived.where(paid: false).all.each do |invoice|
      invoice.archive unless new_invoice == invoice
    end
    return true
  end

  #calculate information for invoice
  def self.calculate_information_for_invoice params

    #get restaurant
    restaurant = Restaurant.find(params[:restaurant_id])
    percentage = restaurant.commission_percentage
    reservations = Reservation.get_for_invoice params

    #get total from all bills
    bill_total = 0
    reservations.all.each do |reservation|
      bill_total += reservation.bill_amount
    end

    #get end of month balance
    transaction = reservations.last.transactions.get_unarchived.where(concernable_type: "Restaurant").first
    final_balance = transaction.final_balance

    #create invoice object
    invoice = {} 
    invoice[:start_date] = params[:start_date].to_date
    invoice[:end_date] = params[:end_date].to_date
    invoice[:business_address] = restaurant.billing_address
    invoice[:client_number] = "A000" + restaurant.id.to_s
    invoice[:facture_number] = "A" + restaurant.id.to_s + '-' + (restaurant.invoices.get_unarchived.count + 1).to_s
    invoice[:pre_tax_owed] = bill_total * percentage
    invoice[:total_owed] =  invoice[:pre_tax_owed] * 1.2 
    invoice[:percentage] = percentage
    invoice[:formatted_percentage] = (percentage * 100).round.to_s + "%"
    invoice[:reservations] = reservations
    invoice[:final_balance] = final_balance
    invoice[:restaurant_id] = restaurant.id

    return invoice
  end

  def full_address
    street + ', ' + city + ', ' + zipcode
  end
end








