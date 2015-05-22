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
