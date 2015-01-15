class RestaurantMailer < ActionMailer::Base
  default from: 'Happy Dining <no-reply@happydining.fr>'

  def new_reservation reservation
  	@reservation = reservation
  	@user = reservation.user
  	@restaurant = reservation.restaurant
  end
end
