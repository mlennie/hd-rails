class Invoice < ActiveRecord::Base

	include Archiving

  belongs_to :restaurant
  belongs_to :invoice_transaction, class_name: :transaction

  def self.make_new invoice_data
  	invoice = Invoice.new({
      start_date: invoice_data[:start_date],
      end_date: invoice_data[:end_date],
      restaurant_id: invoice_data[:restaurant_id],
      facture_number: invoice_data[:facture_number],
      commission_percentage: invoice_data[:percentage],
      pre_tax_owed: invoice_data[:pre_tax_owed],
      total_owed: invoice_data[:total_owed],
      final_balance: invoice_data[:final_balance]
    })

    return invoice
  end

  #get new final balance for invoice by subtracting 
  #last reservation's transaction's final balance by the last final balance of 
  #the last paid invoice
  def self.get_final_balance last_reservation
    transaction = last_reservation.transactions.get_unarchived.where(concernable_type: "Restaurant").first
    restaurant = last_reservation.restaurant
    #get last invoice that is paid
    last_paid_invoice = restaurant.invoices.get_unarchived.where(paid: true).last

    #check if there is a last paid invoice
    if last_paid_invoice
      #get final balance of last paid invoice
      last_final_balance = last_paid_invoice.final_balance
      #calculate new final balance by subtracting the last paid final balance
      #from the new final_balance
      new_final_balance = transaction.final_balance - last_final_balance 
    else #get last final balance from last 
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
end
