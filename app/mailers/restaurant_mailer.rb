class RestaurantMailer < ActionMailer::Base
  default from: 'Happy Dining <admin@happydining.fr>'

  def new_reservation reservation, email
  	@reservation = reservation
  	@time = reservation.time.strftime("%d/%m/%Y, à %H:%M") 
  	@user = reservation.user
    @phone = reservation.phone
    @user_contribution = @reservation.user_contribution
  	@restaurant = reservation.restaurant
  	mail to: email, subject: "Nouvelle réservation de la part de Happy Dining"
  end

  def reservation_validation(booking_name, email)
    @booking_name = booking_name
    mail to: email, subject: "montant de l'addition"
  end

  def invoice_email invoice, email
    params = {}
    params[:start_date] = invoice.start_date
    params[:end_date] = invoice.end_date
    params[:restaurant_id] = invoice.restaurant_id
    params[:commission_only] = invoice.commission_only
    @invoice = Restaurant.calculate_information_for_invoice params
    mail to: email, subject: "Happy Dining Facture #{invoice.start_date.to_date.strftime("%d/%m/%Y")} à #{invoice.end_date.to_date.strftime("%d/%m/%Y")}"
  end
end
