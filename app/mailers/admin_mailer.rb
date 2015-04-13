class AdminMailer < ActionMailer::Base
  default from: 'Happy Dining <no-reply@happydining.fr>'

  def new_reservation reservation
  	@reservation = reservation
  	@time = reservation.time.strftime("%d/%m/%Y, at %H:%M") 
  	@user = reservation.user
  	@restaurant = reservation.restaurant
    @user_contribution = @reservation.user_contribution
  	@email = 'admin@happydining.fr'
  	mail to: @email, subject: "Nouvelle réservation"
  end

  def validation_email_sent booking_name, restaurant_name
  	@restaurant_name = restaurant_name
  	@booking_name = booking_name
  	@email = 'admin@happydining.fr'
  	mail to: @email, subject: "Reservation Validation Email Sent"
  end
end
