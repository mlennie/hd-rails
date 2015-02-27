class AdminMailer < ActionMailer::Base
  default from: 'Happy Dining <no-reply@happydining.fr>'

  def new_reservation reservation
  	@reservation = reservation
  	@time = reservation.time.strftime("%d/%m/%Y, at %H:%M") 
  	@user = reservation.user
  	@restaurant = reservation.restaurant
  	@email = 'admin@happydining.fr'
  	mail to: @email, subject: "Nouvelle réservation"
  end
end
