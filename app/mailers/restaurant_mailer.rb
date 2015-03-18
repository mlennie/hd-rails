class RestaurantMailer < ActionMailer::Base
  default from: 'Happy Dining <admin@happydining.fr>'

  def new_reservation reservation
  	@reservation = reservation
  	@time = reservation.time.strftime("%d/%m/%Y, à %H:%M") 
  	@user = reservation.user
  	@restaurant = reservation.restaurant
  	@email = @restaurant.principle_email
  	mail to: @email, subject: "Nouvelle réservation de la part de Happy Dining"
  end

  def reservation_validation(booking_name, email)
    @booking_name = booking_name
    @email = email
    mail to: @email, subject: "montant de l'addition"
  end
end
