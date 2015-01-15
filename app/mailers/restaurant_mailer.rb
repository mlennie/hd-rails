class RestaurantMailer < ActionMailer::Base
  default from: 'Happy Dining <no-reply@happydining.fr>'

  def new_reservation reservation
  	@reservation = reservation
  	@time = reservation.time.strftime("%m/%d/%Y, at %H:%M") 
  	@user = reservation.user
  	@restaurant = reservation.restaurant
  	@email = @restaurant.principle_email
  	mail to: @email, subject: "New Reservation Through Happy Dining"
  end
end
