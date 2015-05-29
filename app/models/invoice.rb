class Invoice < ActiveRecord::Base

	include Archiving

  belongs_to :restaurant
  has_many :transactions, as: :itemable

  before_update :check_if_unpaying
  after_update :add_transaction_if_paid

  def self.make_new invoice_data
  	invoice = Invoice.new({
      start_date: invoice_data[:start_date],
      end_date: invoice_data[:end_date],
      restaurant_id: invoice_data[:restaurant_id],
      facture_number: invoice_data[:facture_number],
      commission_percentage: invoice_data[:percentage],
      pre_tax_owed: invoice_data[:pre_tax_owed],
      total_owed: invoice_data[:total_owed],
      final_balance: invoice_data[:final_balance],
      commission_only: invoice_data[:commission_only]
    })

    return invoice
  end

  def send_email params
  	if params[:email] == "test"
  		#send test invoice email to admin
      if AdminMailer.invoice_email(self).deliver
      	return true
      else
      	return false
      end
  	elsif params[:email] == "restaurant"
      #get restaurant emails
      invoice = Invoice.find(params[:invoice_id])
      emails = Restaurant.find(invoice.restaurant_id).emails
      #split emails into array
      emailArray = emails.split(' ')
      #send to admin also
      emailArray << ENV["ADMIN_EMAIL"]
      emailArray.each do |email|
        #send invoice email to restaurant
        RestaurantMailer.invoice_email(self, email).deliver 
      end
  	else
  		return false
  	end
  end

  protected

    #throw error if trying to change to unpaid, since code needs to be 
    #added to the add_transaction_if_paid method below to archive last transacton
    #and reset balance when removing paid status
    def check_if_unpaying
      return false if self.paid_changed? && self.paid == false
    end

    #callback after updating. If invoice has been set to paid, create transaction
    def add_transaction_if_paid
      #don't make a transaction if there is already a transaction
      unless self.transactions.get_unarchived.any?
        if self.paid?
          transaction_params = {}
          transaction_params[:restaurant] = Restaurant.find(self.restaurant_id)
          transaction_params[:invoice] = self
          transaction_params[:positive] = true
          transaction_params[:amount] = self.final_balance.abs
          Transaction.create_balance_payment_transaction(transaction_params)
        else #archive last transaction and reset balance since invoice is no
            #longer paid (paid status has been removed)
            #TO DO 
        end
      end
    end
end
