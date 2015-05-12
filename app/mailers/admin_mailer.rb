class AdminMailer < ActionMailer::Base
  default from: 'Happy Dining <no-reply@happydining.fr>'

  def new_reservation reservation
  	@reservation = reservation
  	@time = reservation.time.strftime("%d/%m/%Y, at %H:%M") 
  	@user = reservation.user
  	@restaurant = reservation.restaurant
    @user_contribution = @reservation.user_contribution
    @phone = reservation.phone
  	@email = 'admin@happydining.fr'
  	mail to: @email, subject: "Nouvelle réservation"
  end

  def validation_email_sent booking_name, restaurant_name
  	@restaurant_name = restaurant_name
  	@booking_name = booking_name
  	@email = 'admin@happydining.fr'
  	mail to: @email, subject: "Reservation Validation Email Sent"
  end

  def invoice_email invoice
    params = {}
    params[:start_date] = invoice.start_date
    params[:end_date] = invoice.end_date
    params[:restaurant_id] = invoice.restaurant_id
    restaurant_name = Restaurant.find(invoice.restaurant_id).name
    @invoice = Restaurant.calculate_information_for_invoice params
    @email = 'admin@happydining.fr'
    mail to: @email, subject: "Test Facture Email for #{restaurant_name}"
  end
end
