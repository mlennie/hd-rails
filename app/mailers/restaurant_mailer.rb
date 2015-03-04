class RestaurantMailer < ActionMailer::Base
  default from: 'Happy Dining <no-reply@happydining.fr>'

  def new_reservation reservation
  	@reservation = reservation
  	@time = reservation.time.strftime("%d/%m/%Y, à %H:%M") 
  	@user = reservation.user
  	@restaurant = reservation.restaurant
  	@email = @restaurant.principle_email
  	mail to: @email, subject: "Nouvelle réservation de la part de Happy Dining"
  end

  def google_doc_to_validate_reservation restaurant
  	@restaurant = restaurant
  end
end
